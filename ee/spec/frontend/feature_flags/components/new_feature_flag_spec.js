import Vuex from 'vuex';
import { shallowMount } from '@vue/test-utils';
import { GlAlert } from '@gitlab/ui';
import Form from 'ee/feature_flags/components/form.vue';
import newModule from 'ee/feature_flags/store/modules/new';
import NewFeatureFlag from 'ee/feature_flags/components/new_feature_flag.vue';
import {
  ROLLOUT_STRATEGY_ALL_USERS,
  DEFAULT_PERCENT_ROLLOUT,
  NEW_FLAG_ALERT,
} from 'ee/feature_flags/constants';
import { TEST_HOST } from 'spec/test_constants';
import { allUsersStrategy } from '../mock_data';

describe('New feature flag form', () => {
  let wrapper;

  const store = new Vuex.Store({
    modules: {
      new: newModule,
    },
  });

  const factory = (opts = {}) => {
    if (wrapper) {
      wrapper.destroy();
      wrapper = null;
    }
    wrapper = shallowMount(NewFeatureFlag, {
      propsData: {
        endpoint: `${TEST_HOST}/feature_flags.json`,
        path: '/feature_flags',
        environmentsEndpoint: 'environments.json',
        projectId: '8',
      },
      store,
      provide: {
        glFeatures: {
          featureFlagsNewVersion: true,
        },
      },
      ...opts,
    });
  };

  beforeEach(() => {
    factory();
  });

  afterEach(() => {
    wrapper.destroy();
  });

  describe('with error', () => {
    it('should render the error', () => {
      store.dispatch('new/receiveCreateFeatureFlagError', { message: ['The name is required'] });
      return wrapper.vm.$nextTick(() => {
        expect(wrapper.find('.alert').exists()).toEqual(true);
        expect(wrapper.find('.alert').text()).toContain('The name is required');
      });
    });
  });

  it('renders form title', () => {
    expect(wrapper.find('h3').text()).toEqual('New feature flag');
  });

  it('should render feature flag form', () => {
    expect(wrapper.find(Form).exists()).toEqual(true);
  });

  it('does not render the related issues widget', () => {
    expect(wrapper.find(Form).props('featureFlagIssuesEndpoint')).toBe('');
  });

  it('should render default * row', () => {
    const defaultScope = {
      id: expect.any(String),
      environmentScope: '*',
      active: true,
      rolloutStrategy: ROLLOUT_STRATEGY_ALL_USERS,
      rolloutPercentage: DEFAULT_PERCENT_ROLLOUT,
      rolloutUserIds: '',
    };
    expect(wrapper.vm.scopes).toEqual([defaultScope]);

    expect(wrapper.find(Form).props('scopes')).toContainEqual(defaultScope);
  });

  it('should not alert users that feature flags are changing soon', () => {
    expect(wrapper.contains(GlAlert)).toBe(false);
  });

  it('should pass in the project ID', () => {
    expect(wrapper.find(Form).props('projectId')).toBe('8');
  });

  it('has an all users strategy by default', () => {
    const strategies = wrapper.find(Form).props('strategies');

    expect(strategies).toEqual([allUsersStrategy]);
  });

  describe('without new version flags', () => {
    beforeEach(() => factory({ provide: { glFeatures: { featureFlagsNewVersion: false } } }));

    it('should alert users that feature flags are changing soon', () => {
      expect(wrapper.find(GlAlert).text()).toBe(NEW_FLAG_ALERT);
    });

    it('the new feature flags alert should be dismissable', () => {
      expect(wrapper.find(GlAlert).props('dismissible')).toBe(true);
    });
  });
});
