%{--
  - Copyright (C) 2013-2016 Université Toulouse 3 Paul Sabatier
  -
  -     This program is free software: you can redistribute it and/or modify
  -     it under the terms of the GNU Affero General Public License as published by
  -     the Free Software Foundation, either version 3 of the License, or
  -     (at your option) any later version.
  -
  -     This program is distributed in the hope that it will be useful,
  -     but WITHOUT ANY WARRANTY; without even the implied warranty of
  -     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  -     GNU Affero General Public License for more details.
  -
  -     You should have received a copy of the GNU Affero General Public License
  -     along with this program.  If not, see <http://www.gnu.org/licenses/>.
  --}%

<g:set var="idControllSuffix" value="${parentNote ? parentNote.id : 0}"/>

<div id="edit_tab_${idControllSuffix}">
    <g:form method="post" controller="notes" action="addNote" enctype="multipart/form-data">
        <g:hiddenField name="kind" value="standard"/>
        <g:hiddenField name="inline" value="${params.inline}"/>
        <g:hiddenField name="contextId" value="${context?.id}"
                       id="contextIdInAddForm${idControllSuffix}"/>
        <g:hiddenField name="fragmentTagId" value="${fragmentTag?.id}"/>
        <g:hiddenField name="parentNoteId" value="${parentNote?.id}"/>
        <g:hiddenField name="displaysMyNotes" id="displaysMyNotesInAddForm${idControllSuffix}"/>
        <g:hiddenField name="displaysMyFavorites"
                       id="displaysMyFavoritesInAddForm${idControllSuffix}"/>
        <g:hiddenField name="displaysAll" id="displaysAllInAddForm${idControllSuffix}"/>
        <textarea class="form-control note-editable-content" rows="3" id="noteContent${idControllSuffix}"
                  name="noteContent"
                  maxlength="560">${parentNote ? '@' + parentNote.author?.username + ' ' : ''}</textarea>

        <div class="row">
            <span class="character_counter pull-left" style="margin-left: 15px"
                  id="character_counter${idControllSuffix}"></span>
        </div>

        <div class="row">
            <div class="col-xs-12 col-sm-10 col-md-10 col-lg-10">
                <input type="file" name="myFile" title="Image: gif, jpeg and png only"/>
            </div>

            <div class="col-xs-12 col-sm-2 col-md-2 col-lg-2">
                <button type="submit"
                        class="btn btn-primary btn-xs"
                        id="buttonAddNote${idControllSuffix}"
                        disabled><span
                        class="glyphicon glyphicon-plus"></span>${message(code: "notes.edit.add.note.button")}
                </button>
            </div>
        </div>
    </g:form>
</div>

<r:script>
  $(document).ready(function () {
    // set character counters
    //-----------------------

    // Get the textarea field
    $("#noteContent${idControllSuffix}")

      // Bind the counter function on keyup and blur events
            .bind('keyup blur', function () {
                    // Count the characters and set the counter text
                    var counter =  $("#character_counter${idControllSuffix}");
                    counter.text($(this).val().length + '/560 ${message(code: "notes.edit.characters")}');
                    if ($(this).val().length >1) {
                      $("#buttonAddNote${idControllSuffix}").removeAttr('disabled');
                    } else {
                      $("#buttonAddNote${idControllSuffix}").attr('disabled','disabled');
                    }
                  })

      // Trigger the counter on first load
            .keyup();

    // set hidden field value
    //----------------------
    $("#displaysMyNotesInAddForm${idControllSuffix}").val($("#displaysMyNotes").attr('checked') ? 'on' : '');
    $("#displaysMyFavoritesInAddForm${idControllSuffix}").val($("#displaysMyFavorites").attr('checked') ? 'on' : '');
    $("#displaysAllInAddForm${idControllSuffix}").val($("#displaysAll").attr('checked') ? 'on' : '');
    });
</r:script>