import { GlFilteredSearch } from '@gitlab/ui';
import { shallowMount } from '@vue/test-utils';

import AuditEventsFilter from 'ee/audit_events/components/audit_events_filter.vue';
import { AVAILABLE_TOKEN_TYPES } from 'ee/audit_events/constants';

describe('AuditEventsFilter', () => {
  let wrapper;

  const defaultSelectedTokens = [{ type: 'Project', value: { data: 1, operator: '=' } }];
  const findFilteredSearch = () => wrapper.find(GlFilteredSearch);
  const getAvailableTokens = () => findFilteredSearch().props('availableTokens');
  const getAvailableTokenProps = type =>
    getAvailableTokens().filter(token => token.type === type)[0];

  const initComponent = (props = {}) => {
    wrapper = shallowMount(AuditEventsFilter, {
      propsData: {
        ...props,
      },
    });
  };

  afterEach(() => {
    wrapper.destroy();
    wrapper = null;
  });

  describe.each`
    type         | title
    ${'Project'} | ${'Project Events'}
    ${'Group'}   | ${'Group Events'}
    ${'User'}    | ${'User Events'}
  `('for the list of available tokens', ({ type, title }) => {
    it(`creates a unique token for ${type}`, () => {
      initComponent();
      expect(getAvailableTokenProps(type)).toMatchObject({
        title,
        unique: true,
        operators: [expect.objectContaining({ value: '=' })],
      });
    });
  });

  describe('when the default token value is set', () => {
    beforeEach(() => {
      initComponent({ defaultSelectedTokens });
    });

    it('sets the filtered searched token', () => {
      expect(findFilteredSearch().props('value')).toEqual(defaultSelectedTokens);
    });

    it('only one token matching the selected token type is enabled', () => {
      expect(getAvailableTokenProps('Project').disabled).toEqual(false);
      expect(getAvailableTokenProps('Group').disabled).toEqual(true);
      expect(getAvailableTokenProps('User').disabled).toEqual(true);
    });

    describe('and the user submits the search field', () => {
      beforeEach(() => {
        findFilteredSearch().vm.$emit('submit');
      });

      it('should emit the "submit" event', () => {
        expect(wrapper.emitted().submit).toHaveLength(1);
      });
    });
  });

  describe('when the default token value is not set', () => {
    beforeEach(() => {
      initComponent();
    });

    it('has an empty search value', () => {
      expect(findFilteredSearch().vm.value).toEqual([]);
    });

    describe('and the user inputs nothing into the search field', () => {
      beforeEach(() => {
        findFilteredSearch().vm.$emit('input', []);
      });

      it('should emit the "selected" event with empty values', () => {
        expect(wrapper.emitted().selected[0]).toEqual([[]]);
      });

      describe('and the user submits the search field', () => {
        beforeEach(() => {
          findFilteredSearch().vm.$emit('submit');
        });

        it('should emit the "submit" event', () => {
          expect(wrapper.emitted().submit).toHaveLength(1);
        });
      });
    });
  });

  describe('when enabling just a single token type', () => {
    const type = AVAILABLE_TOKEN_TYPES[0];

    beforeEach(() => {
      initComponent({
        enabledTokenTypes: [type],
      });
    });

    it('only the enabled token type is available for selection', () => {
      expect(getAvailableTokens().length).toEqual(1);
      expect(getAvailableTokens()).toMatchObject([{ type }]);
    });
  });

  describe('when setting the QA selector', () => {
    beforeEach(() => {
      initComponent();
    });

    it('should not set the QA selector if not provided', () => {
      wrapper.vm.$nextTick(() => {
        expect(
          wrapper.find('[data-testid="audit-events-filter"]').attributes('data-qa-selector'),
        ).toBeUndefined();
      });
    });

    it('should set the QA selector if provided', () => {
      wrapper.setProps({ qaSelector: 'qa_selector' });
      wrapper.vm.$nextTick(() => {
        expect(
          wrapper.find('[data-testid="audit-events-filter"]').attributes('data-qa-selector'),
        ).toEqual('qa_selector');
      });
    });
  });
});
