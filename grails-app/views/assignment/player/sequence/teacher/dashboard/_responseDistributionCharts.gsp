%{--
-
-  Copyright (C) 2017 Ticetime
-
-      This program is free software: you can redistribute it and/or modify
-      it under the terms of the GNU Affero General Public License as published by
-      the Free Software Foundation, either version 3 of the License, or
-      (at your option) any later version.
-
-      This program is distributed in the hope that it will be useful,
-      but WITHOUT ANY WARRANTY; without even the implied warranty of
-      MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-      GNU Affero General Public License for more details.
-
-      You should have received a copy of the GNU Affero General Public License
-      along with this program.  If not, see <http://www.gnu.org/licenses/>.
-
--}%

<div style="text-align: center;">
    <div id='vega-view' style=""></div>
</div>

<r:script>
let tsaapData = ${raw(interactionInstance.results)};
let tsaapChoiceSpecification = ${raw(interactionInstance.sequence.statement.choiceSpecification)}
console.info(tsaapChoiceSpecification)
console.info(tsaapData)
if(!_.isEmpty(tsaapData)) {
    let nbItem = tsaapChoiceSpecification.itemCount
    let correctIndexList = []
    _.each(
      tsaapChoiceSpecification.expectedChoiceList,
      choice => correctIndexList.push(choice.index)
      )


    let graphData = []
    _.times(
      nbItem,
      (i => graphData.push({
        category: i,
        amount: tsaapData[1][i+1],
        isCorrect: _.contains(correctIndexList, i+1)
      }))
    )

  console.info(graphData)

    let spec = {
        '$schema': 'https://vega.github.io/schema/vega/v4.json',
        'width': 200,
        'height': 200,
        'padding': 5,

        'data': [
            {
                'name': 'table',
                'values': graphData,
                // [
                //     {'category': 'A', 'amount': 28},
                //     {'category': 'B', 'amount': 55},
                //     {'category': 'C', 'amount': 43},
                //     {'category': 'D', 'amount': 91},
                //     {'category': 'E', 'amount': 81},
                //     {'category': 'F', 'amount': 53},
                //     {'category': 'G', 'amount': 19},
                //     {'category': 'H', 'amount': 87}
                // ]
            }
        ],

        'signals': [
            {
                'name': 'tooltip',
                'value': {},
                'on': [
                    {'events': 'rect:mouseover', 'update': 'datum'},
                    {'events': 'rect:mouseout', 'update': '{}'}
                ]
            }
        ],

        'scales': [
            {
                'name': 'xscale',
                'type': 'band',
                'domain': {'data': 'table', 'field': 'category'},
                'range': 'width',
                'padding': 0.05,
                'round': true
            },
            {
                'name': 'yscale',
                'domain': [0, 100],
                'nice': true,
                'range': 'height'
            }
        ],

        'axes': [
            {
              'orient': 'bottom',
              'scale': 'xscale',
              title: 'Réponse choisie'
              },
            {
              'orient': 'left',
                'scale': 'yscale',
                grid: true,
                // tickCount: 4,
                values: [0, 25, 50, 75, 100],
                title: 'Pourcentage des votants'
            }
        ],

        'marks': [
            {
                'type': 'rect',
                'from': {'data': 'table'},
                'encode': {
                    'enter': {
                        'x': {'scale': 'xscale', 'field': 'category'},
                        'width': {'scale': 'xscale', 'band': 1},
                        'y': {'scale': 'yscale', 'field': 'amount'},
                        'y2': {'scale': 'yscale', 'value': 0}
                    },
                    'update': {
                        'fill': {'value': 'steelblue'}
                    },
                    'hover': {
                        'fill': {
                            'value': 'red'
                        }
                    }
                }
            },
            {
                'type': 'text',
                'encode': {
                    'enter': {
                        'align': {'value': 'center'},
                        'baseline': {'value': 'bottom'},
                        'fill': {'value': '#333'}
                    },
                    'update': {
                        'x': {'scale': 'xscale', 'signal': 'tooltip.category', 'band': 0.5},
                        'y': {'scale': 'yscale', 'signal': 'tooltip.amount', 'offset': -2},
                        'text': {'signal': 'tooltip.amount'},
                        'fillOpacity': [
                            {'test': 'datum === tooltip', 'value': 0},
                            {
                                'value': 1
                            }
                        ]
                    }
                }
            }
        ]
    };

    let view;

    // vega.loader()
    //         .load(json)
    //         .then(function(data) { render(JSON.parse(data)); });
    render(spec);

    function render (spec) {
        view = new vega.View(vega.parse(spec))
                .renderer('canvas')  // set renderer (canvas or svg)
                .initialize('#vega-view') // initialize view within parent DOM container
                .hover()             // enable hover encode set processing
                .run();
    }
}


</r:script>

<div style='font-size: 1rem;' id='interaction_${interactionInstance.id}_result'>
    <g:set var='choiceSpecification' value='${interactionInstance.sequence.statement.getChoiceSpecificationObject()}'/>
    <g:if test='${interactionInstance.sequence.statement.hasChoices()}'>

        <g:set var='choiceSpecification'
               value='${interactionInstance.sequence.statement.getChoiceSpecificationObject()}'/>

        <g:set var='resultsByAttempt' value='${interactionInstance.resultsByAttempt()}'/>
        <g:set var='resultList' value='${resultsByAttempt['1']}'/>
        <g:set var='resultList2' value='${resultsByAttempt['2']}'/>
        <g:each var='i' in='${(1..choiceSpecification.itemCount)}'>
            <g:set var='choiceStatus'
                   value='${choiceSpecification.expectedChoiceListContainsChoiceWithIndex(i) ? 'green' : 'red'}'/>
            <g:set var='percentResult' value='${resultList?.get(i)}'/>
            <g:set var='percentResult2' value='${resultList2?.get(i)}'/>



            <div id='interaction_${interactionInstance.id}_choice_${i}_result'
                 class='ui ${choiceStatus} compact progress'
                 data-percent='${percentResult}'>

                <div class='bar'>
                    <div class='progress'></div>
                </div>
                <g:if test='${percentResult2 == null}'>
                    <div class='label'>${message(code: 'player.sequence.interaction.choice.label')} ${i}</div>
                </g:if>
            </div>

            <g:if test='${percentResult2 != null}'>

                <div class='ui  ${choiceStatus} compact progress' data-percent='${percentResult2}'>
                    <div class='bar'>
                        <div class='progress'></div>
                    </div>

                    <div class='label'>${message(code: 'player.sequence.interaction.choice.label')} ${i}</div>
                </div>
            </g:if>
            <div class='ui hidden divider'></div>

        </g:each>
        <g:set var='percentResult' value='${resultList?.get(0)}'/>
        <g:set var='percentResult2' value='${resultList2?.get(0)}'/>

        <g:if test='${percentResult || percentResult2}'>
            <div class='ui top attached warning small message'>
                <div class='header'>
                    ${message(code: 'player.sequence.interaction.NoResponse.label')}
                </div>
            </div>

            <div class='ui bottom attached segment' style='margin-bottom: 1rem;'>

                <div class='ui warning compact progress'
                     data-percent='${percentResult}'>
                    <div class='bar'>
                        <div class='progress'></div>
                    </div>
                </div>

                <g:if test='${percentResult2 != null}'>
                    <div class='ui yellow compact progress'
                         data-percent='${percentResult2}'>
                        <div class='bar'>
                            <div class='progress'></div>
                        </div>
                    </div>
                </g:if>
            </div>

        </g:if>

    </g:if>
</div>
<r:script>
$('#interaction_${interactionInstance.id}_result .ui.progress').progress({
  autoSuccess: false,
  showActivity: false
});
</r:script>




