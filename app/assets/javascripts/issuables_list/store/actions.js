import axios from '~/lib/utils/axios_utils';
import { __ } from '~/locale';
import flash from '~/flash';

export const fetchIssuabelsSuccess = ({ commit }, data) => {
  commit('SET_ISSUABLES_SUCCESS', data)
};

export const setIssuablesLoading = ({ commit }, bool) => {
  commit('SET_ISSUABLES_LOADING', bool)
};

export const fetchIssuables = ({ dispatch }, { endpoint, params }) => {
  dispatch('setIssuablesLoading', true);

  return axios.get(endpoint, params)
    .then((data) => {
      dispatch('setIssuablesLoading', false);
      dispatch('fetchIssuabelsSuccess', data);
    })
    .catch(() => {
      dispatch('setIssuablesLoading', false);

      return flash(__('An error occurred while loading issues'));
    });
};
