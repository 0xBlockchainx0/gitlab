  /* global Flash */
/* eslint-disable no-new */
import '~/flash';
import Vue from 'vue';
import PipelinesService from './services/pipelines_service';
import eventHub from './event_hub';
import PipelinesTableComponent from '../vue_shared/components/pipelines_table';
import TablePaginationComponent from '../vue_shared/components/table_pagination';

export default {
  props: {
    store: {
      type: Object,
      required: true,
    },
  },

  components: {
    'gl-pagination': TablePaginationComponent,
    'pipelines-table-component': PipelinesTableComponent,
  },

  data() {
    const pipelinesData = document.querySelector('#pipelines-list-vue').dataset;

<<<<<<< HEAD
    return {
      ...pipelinesData,
      pipelines: [],
      apiScope: 'all',
      pageInfo: {},
      pagenum: 1,
      count: {},
      pageRequest: false,
      hasError: false,
      pipelinesEmptyStateSVG,
      pipelinesErrorStateSVG,
    };
  },

  computed: {
    canCreatePipelineParsed() {
      return gl.utils.convertPermissionToBoolean(this.canCreatePipeline);
    },

    scope() {
      return gl.utils.getParameterByName('scope');
    },

    shouldRenderErrorState() {
      return this.hasError && !this.pageRequest;
    },

    /**
     * The empty state should only be rendered when the request is made to fetch all pipelines
     * and none is returned.
     *
     * @return {Boolean}
     */
    shouldRenderEmptyState() {
      return !this.hasError &&
        !this.pageRequest && (
          !this.pipelines.length && (this.scope === 'all' || this.scope === null)
        );
    },

    shouldRenderTable() {
      return !this.hasError &&
        !this.pageRequest && this.pipelines.length;
    },
    template: `
      <div :class="cssClass">
        <div class="top-area" v-if="!shouldRenderEmptyState">
          <ul
            class="nav-links">

            <li :class="{ 'active': scope === null || scope === 'all'}">
              <a :href="allPath">
                All
              </a>
              <span class="badge js-totalbuilds-count">
                {{count.all}}
              </span>
            </li>
            <li
              class="js-pipelines-tab-pending"
              :class="{ 'active': scope === 'pending'}">
              <a :href="pendingPath">
                Pending
              </a>

              <span class="badge">
                {{count.pending}}
              </span>
            </li>
            <li
              class="js-pipelines-tab-running"
              :class="{ 'active': scope === 'running'}">

              <a :href="runningPath">
                Running
              </a>

              <span class="badge">
                {{count.running}}
              </span>
            </li>

            <li
              class="js-pipelines-tab-finished"
              :class="{ 'active': scope === 'finished'}">

              <a :href="finishedPath">
                Finished
              </a>
              <span class="badge">
                {{count.finished}}
              </span>
            </li>

            <li
            class="js-pipelines-tab-branches"
            :class="{ 'active': scope === 'branches'}">
              <a :href="branchesPath">Branches</a>
            </li>

            <li
              class="js-pipelines-tab-tags"
              :class="{ 'active': scope === 'tags'}">
              <a :href="tagsPath">Tags</a>
            </li>
          </ul>

          <div class="nav-controls">
            <a
              v-if="canCreatePipelineParsed"
              :href="newPipelinePath"
              class="btn btn-create">
              Run Pipeline
            </a>
          </div>

        <div class="pipelines realtime-loading"
          v-if="pageRequest">
          <i class="fa fa-spinner fa-spin" aria-hidden="true"></i>
        </div>

        <div v-if="shouldRenderEmptyState"
          class="row empty-state">
          <div class="col-xs-12 pull-right">
            <div class="svg-content">
              ${pipelinesEmptyStateSVG}
            </div>
          </div>

          <div class="col-xs-12 center">
            <div class="text-content">
              <h4>Build with confidence</h4>
              <p>
                Continous Integration can help catch bugs by running your tests automatically,
                while Continuous Deployment can help you deliver code to your product environment.
                <a :href="helpPagePath" class="btn btn-info">
                  Get started with Pipelines
                </a>
              </p>
            </div>
          </div>
        </div>

      <div v-if="shouldRenderErrorState"
        class="row empty-state">
        <div class="col-xs-12 pull-right">
          <div class="svg-content">
            ${pipelinesErrorStateSVG}
          </div>
        </div>

        <div class="col-xs-12 center">
          <div class="text-content">
            <h4>The API failed to fetch the pipelines.</h4>
          </div>
        </div>
      </div>

      <div class="table-holder"
        v-if="shouldRenderTable">
        <pipelines-table-component :pipelines='pipelines'/>
      </div>

      <gl-pagination
        v-if="shouldRenderPagination"
        :pagenum="pagenum"
        :change="change"
        :count="count.all"
        :pageInfo="pageInfo"/>
    </div>
  `,
};
