/*
 * Copyright (C) 2013-2016 Université Toulouse 3 Paul Sabatier
 *
 *     This program is free software: you can redistribute it and/or modify
 *     it under the terms of the GNU Affero General Public License as published by
 *     the Free Software Foundation, either version 3 of the License, or
 *     (at your option) any later version.
 *
 *     This program is distributed in the hope that it will be useful,
 *     but WITHOUT ANY WARRANTY; without even the implied warranty of
 *     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *     GNU Affero General Public License for more details.
 *
 *     You should have received a copy of the GNU Affero General Public License
 *     along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

modules = {
  application {
    resource url: 'js/application.js'
  }

  vue_js {
    resource url: 'js/vuejs/vue.js', linkOverride: 'https://unpkg.com/vue'
    resource url: 'js/vuejs/vue-resource.min.js', linkOverride: 'https://cdn.jsdelivr.net/vue.resource/1.3.1/vue-resource.min.js'
  }

  ckeditor_vue_js {
    dependsOn('vue_js')
    resource url: 'js/elaastic/VueCkeditorComponent.js'
  }

  underscore_js {
    resource url: 'js/underscore-min.js'
  }

  semantic_ui {
    dependsOn('jquery')
    resource url: 'semantic/dist/semantic.min.css'
    resource url: 'semantic/dist/semantic.min.js'
  }

  elaastic_ui {
    resource url: 'css/elaastic.css'
    resource url: 'js/elaastic/util.js'
  }

  tsaap_ui {
    dependsOn('application')
    dependsOn('jquery')
    resource url: 'js/moment.js'
    resource url: 'js/locale/fr.js'
    resource url: 'js/bootstrap.min.js'
    resource url: 'css/bootstrap.min.css'
    resource url: 'js/bootstrap-datetimepicker.js'
    resource url: 'js/star-rating.min.js'
    resource url: 'css/star-rating.min.css'
    resource url: 'js/locales/fr.js'
  }

  tsaap_icons {
    dependsOn('tsaap_ui')
    resource url: 'css/bootstrap-glyphicons.css'
    resource url: 'css/docs.css'
  }

  tsaap_ui_home {
    dependsOn('tsaap_ui')
    resource url: 'css/jumbotron.css'
  }

  tsaap_ui_signin {
    dependsOn('tsaap_ui')
    resource url: 'css/signin.css'
  }

  tsaap_ui_notes {
    dependsOn('tsaap_ui')
    resource url: 'css/notes.css'
  }
}