import { mount } from '@vue/test-utils';
import { GlFormInput, GlLink } from '@gitlab/ui';
import FormInput from 'ee/security_configuration/sast/components/form_input.vue';
import { SCHEMA_TO_PROP_SIZE_MAP } from 'ee/security_configuration/sast/components/constants';

describe('FormInput component', () => {
  let wrapper;

  const testProps = {
    field: 'field',
    label: 'label',
    description: 'description',
    defaultValue: 'defaultValue',
    value: 'defaultValue',
  };
  const newValue = 'foo';

  const createComponent = ({ props = {} } = {}) => {
    wrapper = mount(FormInput, {
      propsData: {
        ...props,
      },
    });
  };

  const findInput = () => wrapper.find('input');
  const findLabel = () => wrapper.find('label');
  const findInputComponent = () => wrapper.find(GlFormInput);
  const findRestoreDefaultLink = () => wrapper.find(GlLink);

  afterEach(() => {
    wrapper.destroy();
    wrapper = null;
  });

  describe('label', () => {
    beforeEach(() => {
      createComponent({
        props: testProps,
      });
    });

    it('renders the label', () => {
      expect(findLabel().text()).toContain(testProps.label);
    });

    it('renders the description', () => {
      expect(findLabel().text()).toContain(testProps.description);
    });
  });

  describe('input', () => {
    beforeEach(() => {
      createComponent({
        props: testProps,
      });
    });

    it('sets the input to the value', () => {
      expect(findInput().element.value).toBe(testProps.value);
    });

    it('is connected to the label', () => {
      expect(findInput().attributes('id')).toBe(testProps.field);
      expect(findLabel().attributes('for')).toBe(testProps.field);
    });

    describe('when the user changes the value', () => {
      beforeEach(() => {
        findInput().setValue(newValue);
      });

      it('emits an input event with the new value', () => {
        expect(wrapper.emitted('input')).toEqual([[newValue]]);
      });
    });
  });

  describe('custom value message', () => {
    describe('given the value equals the custom value', () => {
      beforeEach(() => {
        createComponent({
          props: testProps,
        });
      });

      it('does not display the custom value message', () => {
        expect(findRestoreDefaultLink().exists()).toBe(false);
      });
    });

    describe('given the value differs from the custom value', () => {
      beforeEach(() => {
        createComponent({
          props: {
            ...testProps,
            value: newValue,
          },
        });
      });

      it('displays the custom value message', () => {
        expect(findRestoreDefaultLink().exists()).toBe(true);
      });

      describe('clicking on the restore default link', () => {
        beforeEach(() => {
          findRestoreDefaultLink().trigger('click');
        });

        it('emits an input event with the default value', () => {
          expect(wrapper.emitted('input')).toEqual([[testProps.defaultValue]]);
        });
      });
    });
  });

  // TODO: unskip once
  // https://gitlab.com/gitlab-org/gitlab-ui/-/merge_requests/1604 merges.
  describe.skip('size prop', () => {
    it.each(Object.entries(SCHEMA_TO_PROP_SIZE_MAP))(
      'maps the %p size prop to %p',
      (size, mappedSize) => {
        createComponent({
          props: {
            ...testProps,
            size,
          },
        });

        expect(findInputComponent().props('size')).toBe(mappedSize);
      },
    );
  });
});
