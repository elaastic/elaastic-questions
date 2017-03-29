<%@ page import="org.tsaap.assignments.Schedule; org.tsaap.assignments.interactions.ResponseSubmissionSpecification; org.tsaap.assignments.statement.ChoiceInteractionType" %>
<g:set var="responseSubmissionSpecificationInstance" value="${sequenceInstance?.responseSubmissionSpecification ?: new ResponseSubmissionSpecification()}"/>
<div class="panel panel-default">
    <div class="panel-heading">
        <g:message code="statement.questionType.label"/>
    </div>

    <div class="panel-body">
        <div class="checkbox">
            <label>
                <input
                    type="radio"
                    value="true"
                    name="hasChoices"
                    ${sequenceInstance?.statement ? '' : 'checked'}
                    ${sequenceInstance?.statement?.hasChoices() ? 'checked' : ''}>
                <g:message code="sequence.interaction.studentsSelect"/>
            <g:select name="choiceInteractionType" id="choiceInteractionType"
                      from="${ChoiceInteractionType.values()*.name()}"
                      value="${sequenceInstance?.statement?.choiceSpecificationObject?.getChoiceInteractionType()}"/> <g:message code="sequence.interaction.choicesIn"/>
            <g:select name="itemCount" id="itemCount" from="${2..10}"
                      value="${sequenceInstance?.statement?.choiceSpecificationObject?.itemCount}"/><g:message code="sequence.interaction.items"/>
            </label>
        </div>
        <g:set var="itemCount" value="${sequenceInstance?.statement?.choiceSpecificationObject?.itemCount ?: 2}"/>
        <g:set var="isMultipleChoice" value="${sequenceInstance?.statement?.isMultipleChoice() ?: false}"/>
        <div class="checkbox text-center ${isMultipleChoice ? '' : 'hidden'}" id="multiple_choice">
            <g:each in="${1..itemCount}" var="checkBoxElet" status="i">
                <g:set var="choiceIsExpected"
                       value="${sequenceInstance?.statement?.choiceSpecificationObject?.choiceWithIndexInExpectedChoiceList(i + 1)}"/>
                <label class="checkbox-inline" style="margin-right: 20px">
                    <input type="checkbox" name="expectedChoiceList"
                           value="${i + 1}" ${choiceIsExpected ? 'checked' : ''}> ${i + 1}
                </label>
            </g:each>
        </div>

        <div class="radio text-center ${isMultipleChoice ? 'hidden' : ''}" id="exclusive_choice" title="${message(code:'sequence.interaction.expectedChoice.hasToBeSelected')}">
            <g:each in="${1..itemCount}" var="radioBoxElet" status="i">
                <g:set var="choiceIsExpected"
                       value="${sequenceInstance?.statement?.choiceSpecificationObject?.choiceWithIndexInExpectedChoiceList(i + 1)}"/>
                <label class="radio-inline" style="margin-right: 20px">
                    <input type="radio" name="exclusiveChoice"
                           value="${i + 1}" ${choiceIsExpected ? 'checked' : ''}> ${i + 1}
                </label>
            </g:each>
        </div>
        <div class="accordion" id="accordionExplanations" style="margin-left: 2%;">
          <div class="accordion-group">
            <div class="accordion-heading">
              <a class="accordion-toggle" data-toggle="collapse" data-parent="#accordionExplanations" href="#collapseOne" style="margin-left: 5%">
                Provides explanation
              </a>
            </div>
            <div id="collapseOne" class="accordion-body collapse" style="padding-left: 5%">
              <g:set var="explanationCount" value="${sequenceInstance?.statement?.choiceSpecificationObject?.explanationChoiceList?.size()?: 2}"/>
              <div class="accordion-inner" id="teacherExplanation">
                <g:each var="index" in="${1..explanationCount}">
                  <div style="margin-top: 10px" id="test_${index}">
                    <label> Explanation for choice ${index}</label>
                    <ckeditor:editor name="explanations" id="explanation_${index}" height="7em">
                      ${statementInstance?.choiceSpecificationObject?.explanationWithIndexInExplanationChoiceList(index)?.explanation}
                    </ckeditor:editor>
                  </div>
                </g:each>
              </div>
            </div>
          </div>
        </div>

        <div class="checkbox">
            <label>
              <input type="radio" value="false" id="radioOpenEnded" name="hasChoices"  ${sequenceInstance?.statement?.isOpenEnded() ? 'checked' : ''}> <g:message code="sequence.interaction.openEnded"/>
            </label>
        </div>
    </div>
</div>

<r:script>
    init();
    console.log(CKEDITOR);
    function init () {
      if ($('#radioOpenEnded').is(':checked')) {
        $('#multiple_choice').addClass('hidden');
        $('#exclusive_choice').addClass('hidden');
        $("#itemCount").prop('disabled',true);
        $("#choiceInteractionType").prop('disabled', true);
      }

      if ($("input:radio[name='exclusiveChoice']:checked").val() === undefined) {
        $("input:radio[name='exclusiveChoice']")[0].checked = true;
      }
    }

    function manageHasChoices(input) {
        if (input.value === 'true') {
            $("#itemCount").prop('disabled',false);
            $("#choiceInteractionType").prop('disabled', false);
            if ($('#choiceInteractionType').val() === 'MULTIPLE') {
                $('#multiple_choice').removeClass('hidden');
            } else {
                $('#exclusive_choice').removeClass('hidden');
            }

            if ($("input:radio[name='exclusiveChoice']:checked").val() === undefined) {
                manageChoices()
            }
        } else {
            $("#itemCount").prop('disabled',true);
            $("#choiceInteractionType").prop('disabled', true);
            if ($('#choiceInteractionType').val() === 'MULTIPLE') {
                $('#multiple_choice').addClass('hidden');
            } else {
                $('#exclusive_choice').addClass('hidden');
            }
        }
    }

    function manageChoices() {
        var isOpenEnded = $('#radioOpenEnded').is(':checked');
        if (!isOpenEnded) {
          var isMultiple = ($("#choiceInteractionType").val() == "MULTIPLE");
          if (isMultiple) {
            $('#multiple_choice').removeClass('hidden');
            $('#exclusive_choice').addClass('hidden');
            $("#multiple_choice").empty();
            for (var i = 1; i <= $("#itemCount").val(); i++) {
              var chckBox = $('<label class="checkbox-inline" style="margin-right: 20px"> <input type="checkbox" name="expectedChoiceList" value="' + i + '"> ' + i + ' </label>');
              $("#multiple_choice").append(chckBox);
              if (i == 1) {
                chckBox.find('input').prop( "checked", true );
              }
            }
          } else {
            $('#exclusive_choice').removeClass('hidden');
            $('#multiple_choice').addClass('hidden');
            $('#exclusive_choice').empty();
            for (var j = 1; j <= $("#itemCount").val(); j++) {
              var currentRadioBox = $('<label class="radio-inline" style="margin-right: 20px"> <input type="radio" name="exclusiveChoice" value="' + j + '"> ' + j + ' </label>');
              $("#exclusive_choice").append(currentRadioBox);
              if (j == 1) {
                currentRadioBox.find('input').prop( "checked", true );
              }
            }
          }
        }
    }


    function manageExplanationChoice() {
      var explanationCount = $("#itemCount").val();
      var teacherExplanation = $('#teacherExplanation');
      teacherExplanation.empty();
      for (var i = 1; i <= explanationCount; i++) {
        var div = '<div style="margin-top: 10px">';
        var textarea = '<textarea name="explanations" id="explanation_' + i +'">' + '</textarea>'
        var explanationTextArea = $(div + '<label> Explanation for choice' + i +'</label>' + textarea +'</div>');
        teacherExplanation.append(explanationTextArea);
        CKEDITOR.replace('explanation_' + i, {
          customConfig: '/ckeditor/config.js',
          height: '110px'
        });
      }
    }

    // Listeners
    $("input:radio[name='hasChoices']").change(function() {
    manageHasChoices(this)
    });

    $("#choiceInteractionType, #itemCount").change(function () {
    manageChoices()
    manageExplanationChoice()
    });
</r:script>