{set scope=global persistent_variable=hash('breadcrumb', false())}

{ezscript_require( array(  'ezjsc::yui2', 'ezjsc::yui3', 'ezjsc::yui3io', 'ezajaxsearch.js' ) )}

{ezscript_require(array(
    'ezjsc::jquery',
    'ezjsc::jqueryUI',
    'bootstrap.min.js',
    'bootstrap/tooltip.js',
    'bootstrap/popover.js',
    'plugins/chosen.jquery.js',
    'moment.min.js',
    'jquery.dataTables.js',
    'dataTables.bootstrap.js',
    'jquery.opendataDataTable.js',
    'jquery.opendataTools.js',

    'handlebars.min.js',
    'moment-with-locales.min.js',
    'bootstrap-datetimepicker.min.js',
    'jquery.fileupload.js',
    'jquery.fileupload-process.js',
    'jquery.fileupload-ui.js',
    'jquery.tag-editor.js',
    'popper.min.js',
    'alpaca.js',
    'leaflet/leaflet.0.7.2.js',
    'leaflet/Control.Geocoder.js',
    'leaflet/Control.Loading.js',
    'leaflet/Leaflet.MakiMarkers.js',
    'leaflet/leaflet.activearea.js',
    'leaflet/leaflet.markercluster.js',
    'jquery.price_format.min.js',
    'jquery.opendatabrowse.js',
    'fields/OpenStreetMap.js',
    'fields/RelationBrowse.js',
    'fields/LocationBrowse.js',
    'fields/Tags.js',
    'jquery.opendataform.js'
))}

<script type="text/javascript" src={'javascript/summernote/summernote-bs4.js'|ezdesign()} charset="utf-8"></script>

{ezcss_require(array(
    'ocbootstrap.css',
    'alpaca.min.css',
    'leaflet/leaflet.0.7.2.css',
    'leaflet/Control.Loading.css',
    'leaflet/MarkerCluster.css',
    'leaflet/MarkerCluster.Default.css',
    'bootstrap-datetimepicker.min.css',
    'jquery.fileupload.css',
    'summernote/summernote-bs4.css',
    'jquery.tag-editor.css',
    'alpaca-custom.css'
))}


{let class_content=$attribute.class_content
     class_list=fetch( class, list, hash( class_filter, $class_content.class_constraint_list ) )
     can_create=true()
     new_object_initial_node_placement=false()
     browse_object_start_node=false()}

{default html_class='full' placeholder=false()}

<fieldset class="Form-field {if array(2,3)|contains($class_content.selection_type)}Form-field--choose Grid-cell{/if} {if $attribute.has_validation_error} has-error{/if}">
    <legend class="Form-label {if $attribute.is_required}is-required{/if}">
        {first_set( $contentclass_attribute.nameList[$content_language], $contentclass_attribute.name )|wash}
        {if $attribute.is_information_collector} <em class="collector">{'information collector'|i18n( 'design/admin/content/edit_attribute' )}</em>{/if}
        {if $attribute.is_required} ({'richiesto'|i18n('design/ocbootstrap/designitalia')}){/if}
    </legend>

    {if $contentclass_attribute.description}
        <em class="attribute-description">{first_set( $contentclass_attribute.descriptionList[$content_language], $contentclass_attribute.description)|wash}</em>
    {/if}

{* If current selection mode is not 'browse'. *}
{if $class_content.selection_type|ne( 0 )} 
        {default attribute_base=ContentObjectAttribute}
        {let parent_node=cond( and( is_set( $class_content.default_placement.node_id ),
                               $class_content.default_placement.node_id|eq( 0 )|not ),
                               $class_content.default_placement.node_id, 1 )         
         nodesList=cond( and( is_set( $class_content.class_constraint_list ), $class_content.class_constraint_list|count|ne( 0 ) ),
                         fetch( content, tree,
                                hash( parent_node_id, $parent_node,
                                      class_filter_type,'include',
                                      class_filter_array, $class_content.class_constraint_list,
                                      sort_by, array( 'name',true() ),
                                      main_node_only, true() ) ),
                         fetch( content, list,
                                hash( parent_node_id, $parent_node,
                                      sort_by, array( 'name', true() )
                                     ) )
                        )
        }
        {switch match=$class_content.selection_type}

        {* Dropdown list *}
        {case match=1} 
            <input type="hidden" name="single_select_{$attribute.id}" value="1" />
            {if ne( count( $nodesList ), 0)}
            <select class="Form-input" name="{$attribute_base}_data_object_relation_list_{$attribute.id}[]">
                {if $attribute.contentclass_attribute.is_required|not}
                    <option value="no_relation" {if eq( $attribute.content.relation_list|count, 0 )} selected="selected"{/if}> </option>
                {/if}
                {section var=node loop=$nodesList}
                    <option value="{$node.contentobject_id}"
                    {if ne( count( $attribute.content.relation_list ), 0)}
                    {foreach $attribute.content.relation_list as $item}
                         {if eq( $item.contentobject_id, $node.contentobject_id )}
                            selected="selected"
                            {break}
                         {/if}
                    {/foreach}
                    {/if}
                    >
                    {$node.name|wash}</option>
                {/section}
            </select>
            {/if}
        {/case}

        {* radio buttons list *}
        {case match=2} 
            <input type="hidden" name="single_select_{$attribute.id}" value="1" />
            {if $attribute.contentclass_attribute.is_required|not}
                <label class="Form-label Form-label--block">
                  <input type="radio" class="Form-input" name="{$attribute_base}_data_object_relation_list_{$attribute.id}[]" value="no_relation"{if eq( $attribute.content.relation_list|count, 0 )} checked="checked"{/if} />
                    <span class="Form-fieldIcon" role="presentation"></span> {'No relation'|i18n( 'design/standard/content/datatype' )}
                </label>
            {/if}
                
            {section var=node loop=$nodesList}
                <label class="Form-label Form-label--block">
                <input type="radio" class="Form-input" name="{$attribute_base}_data_object_relation_list_{$attribute.id}[]" value="{$node.contentobject_id}"
                {if ne( count( $attribute.content.relation_list ), 0)}
                {foreach $attribute.content.relation_list as $item}
                     {if eq( $item.contentobject_id, $node.contentobject_id )}
                            checked="checked"
                            {break}
                     {/if}
                {/foreach}
                {/if}
                >
                    <span class="Form-fieldIcon" role="presentation"></span> {$node.name|wash} <small class="u-text-xxs u-color-grey-40">{$node.url_alias|shorten(70, '...', 'middle')|wash}</small>
                </label>
            {/section}
        {/case}

        {case match=3} {* check boxes list *}
            {section var=node loop=$nodesList}
                <label class="Form-label Form-label--block">
                <input class="Form-input" type="checkbox" name="{$attribute_base}_data_object_relation_list_{$attribute.id}[{$node.node_id}]" value="{$node.contentobject_id}"
                {if ne( count( $attribute.content.relation_list ), 0)}
                {foreach $attribute.content.relation_list as $item}
                     {if eq( $item.contentobject_id, $node.contentobject_id )}
                            checked="checked"
                            {break}
                     {/if}
                {/foreach}
                {/if}
                />
                        <span class="Form-fieldIcon" role="presentation"></span> {$node.name|wash} <small class="u-text-xxs u-color-grey-40">{$node.url_alias|shorten(70, '...', 'middle')|wash}</small>
                </label>
            {/section}
        {/case}

        {* Multiple List *}
        {case match=4} 
            {if ne( count( $nodesList ), 0)}
            <select class="{$html_class}" name="{$attribute_base}_data_object_relation_list_{$attribute.id}[]" size="10" multiple>
                {section var=node loop=$nodesList}
                    <option value="{$node.contentobject_id}"
                    {if ne( count( $attribute.content.relation_list ), 0)}
                    {foreach $attribute.content.relation_list as $item}
                         {if eq( $item.contentobject_id, $node.contentobject_id )}
                            selected="selected"
                            {break}
                         {/if}
                    {/foreach}
                    {/if}
                    >
                    {$node.name|wash}</option>
                {/section}
            </select>
            {/if}
        {/case}

        {* Template based, multi *}
        {case match=5} 
            <div class="templatebasedeor">
                {section var=node loop=$nodesList}
                   <<div class="checkbox"><label>
                        <input type="checkbox" name="{$attribute_base}_data_object_relation_list_{$attribute.id}[{$node.node_id}]" value="{$node.contentobject_id}"
                        {if ne( count( $attribute.content.relation_list ), 0)}
                        {foreach $attribute.content.relation_list as $item}
                           {if eq( $item.contentobject_id, $node.contentobject_id )}
                               checked="checked"
                               {break}
                           {/if}
                        {/foreach}
                        {/if}
                        >
                        {node_view_gui content_node=$node view=objectrelationlist}
                   </label></<div>
                {/section}
            </div>
        {/case}

        {* Template based, single *}
        {case match=6} 
            <div class="templatebasedeor">
                {if $attribute.contentclass_attribute.is_required|not}
                    <div class="radio"><label>
                    <input value="no_relation" type="radio" name="{$attribute_base}_data_object_relation_list_{$attribute.id}[]" {if eq( $attribute.content.relation_list|count, 0 )} checked="checked"{/if}>{'No relation'|i18n( 'design/standard/content/datatype' )}<br />
                    </label></<div>
                {/if}
                {section var=node loop=$nodesList}
                    <div class="radio"><label>
                        <input type="radio" name="{$attribute_base}_data_object_relation_list_{$attribute.id}[]" value="{$node.contentobject_id}"
                        {if ne( count( $attribute.content.relation_list ), 0)}
                        {foreach $attribute.content.relation_list as $item}
                           {if eq( $item.contentobject_id, $node.contentobject_id )}
                               checked="checked"
                               {break}
                           {/if}
                        {/foreach}
                        {/if}
                        >
                        {node_view_gui content_node=$node view=objectrelationlist}
                    </label></<div>
                {/section}
           </div>
        {/case}
        {/switch}

        {if eq( count( $nodesList ), 0 )}
            {def $parentnode = fetch( 'content', 'node', hash( 'node_id', $parent_node ) )}
            {if is_set( $parentnode )}
                <p><strong>{'Parent node'|i18n( 'design/standard/content/datatype' )}:</strong> <a href={$parentnode.url_alias|ezurl()}>{$parentnode.name|wash()}</a></p>
            {/if}
            <p><strong>{'Allowed classes'|i18n( 'design/standard/content/datatype' )}:</strong>
            {if ne( count( $class_content.class_constraint_list ), 0 )}
                 {foreach $class_content.class_constraint_list as $class}
                    {$class}
                    {delimiter}, {/delimiter}
                 {/foreach}
            {else}
                {'Any'|i18n( 'design/standard/content/datatype' )}
            {/if}
            </p>
            <div class="alert alert-warning"><p>{'There are no objects of allowed classes'|i18n( 'design/standard/content/datatype' )}.</p></div>
        {/if}


        {/let}
        {/default}
{* Standard mode is browsing *}
{else}
    <div class="block relations-searchbox" id="ezobjectrelationlist_browse_{$attribute.id}">
    {if is_set( $attribute.class_content.default_placement.node_id )}
         {set browse_object_start_node = $attribute.class_content.default_placement.node_id}
    {/if}

    {* Optional controls. *}
    {include uri='design:content/datatype/edit/ezobjectrelationlist_controls.tpl'}
        <div class="table-responsive">
        <table class="table table-condensed{if $attribute.content.relation_list|not} hide{/if}" cellspacing="0">
        <thead>
        <tr>
            <th class="tight"></th>
            <th><small>{'Name'|i18n( 'design/standard/content/datatype' )}</small></th>
            <th>{'Section'|i18n( 'design/standard/content/datatype' )}</th>
            <th>{'Published'|i18n( 'design/standard/content/datatype' )}</th>
            <th class="tight">{'Order'|i18n( 'design/standard/content/datatype' )}</th>
        </tr>
        </thead>
        <tbody>
        {if $attribute.content.relation_list}
            {foreach $attribute.content.relation_list as $item sequence array( 'bglight', 'bgdark' ) as $style}
			  {include name=relation_item uri='design:ezjsctemplate/relation_list_row.tpl' arguments=array( $item.contentobject_id, $attribute.id, $item.priority )}
            {/foreach}
        {/if}
        <tr class="hide">
          <td class="tight">
              <input type="checkbox" name="{$attribute_base}_selection[{$attribute.id}][]" value="--id--" class="Form-input" />
              <input type="hidden" name="{$attribute_base}_data_object_relation_list_{$attribute.id}[]" value="no_relation" />
          </td>
          <td><small></small></td>
          <td><small></small></td>
          <td><small></small></td>
          <td><input size="2" type="text" name="{$attribute_base}_priority[{$attribute.id}][]" value="0" /></td>
        </tr>
        <tr class="buttons">
          <td>
            <button class="btn btn-sm ezobject-relation-remove-button {if $attribute.content.relation_list|not()}hide{/if}" type="submit" name="CustomActionButton[{$attribute.id}_remove_objects]">
              <span class="fa fa-trash"></span>
            </button>
          </td>
          <td></td>
          <td></td>
          <td></td>
          <td></td>
        </tr>
        </tbody>
        </table>

        </div>


        {if $browse_object_start_node}
            <input type="hidden" name="{$attribute_base}_browse_for_object_start_node[{$attribute.id}]" value="{$browse_object_start_node|wash}" />
        {/if}

        {if is_set( $attribute.class_content.class_constraint_list[0] )}
            <input type="hidden" name="{$attribute_base}_browse_for_object_class_constraint_list[{$attribute.id}]" value="{$attribute.class_content.class_constraint_list|implode(',')}" />
        {/if}

        <div class="Grid">
            <div class="Grid-cell u-size12of12 u-sm-size12of12 u-md-size5of12 u-lg-size5of12">
                <button class="btn" type="submit" name="CustomActionButton[{$attribute.id}_browse_objects]">
                    {'Add existing objects'|i18n( 'design/standard/content/datatype' )}
                </button>

                <a class="btn opendataform-create-{$attribute.id}" data-class="{$attribute.contentclass_attribute.content.class_constraint_list[0]}" data-parent="{$attribute.contentclass_attribute.content.default_placement.node_id}" role="button">
                    Crea nuovo oggetto
                </a>
            </div>
            <div class="Grid-cell u-size12of12 u-sm-size12of12 u-md-size3of12 u-lg-size3of12">
                {include uri='design:content/datatype/edit/ezobjectrelationlist_ajaxuploader.tpl'}
            </div>
            <div class="Grid-cell u-size12of12 u-sm-size12of12 u-md-size4of12 u-lg-size4of12">
                <div class="Form-field Form-field--withPlaceholder Form--Grid-cell u-sizeFull u-sm-size6of12 u-md-size4of12 u-lg-size3of12">
                    <input type="text" class="ezobject-relation-search-text" />
                    <button type="submit"
                            data-no_result="Nessun risultato per --search-string--"
                            class="ezobject-relation-search-btn u-background-40 u-padding-all-s u-color-white"
                            name="CustomActionButton[{$attribute.id}_browse_objects]">
                        <span class="fa fa-search"></span>
                    </button>
                </div>
            </div>
        </div>

        <ul class="u-border-top-m u-background-white inline-block ezobject-relation-search-browse hide"></ul>

        {ezscript_require( array( 'ezjsc::jquery', 'ezjsc::jqueryio', 'plugins/edit.js' ) )}

    </div><!-- /div class="block" id="ezobjectrelationlist_browse_{$attribute.id}" -->
{/if}

</fieldset>


<div id="details-modal" class="modal fade">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                <h2 class="modal-title" id="modal-title">Attendi fino a quando il file verrà caricato</h2>
            </div>
            <div class="modal-body" id="modal-body"></div>
        </div>
    </div>
</div>

<div id="modal" class="modal fade">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <div class="modal-body">
                <div class="clearfix">
                    <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                </div>
                <div id="modal_form"></div>
            </div>
        </div>
    </div>
</div>

{/default}
{/let}

<script type="text/javascript" language="javascript" class="init">

    {literal}
    $(document).ready(function () {

        var modal_form = $('#modal_form');

        $('.opendataform-create-{/literal}{$attribute.id}{literal}').on('click', function(e){
            var classIdentifier = $(this).data('class');
            var parentNode = $(this).data('parent');

            modal_form.opendataFormCreate({
                "class": classIdentifier,
                "parent": parentNode
            },{
                "onSuccess": function(data){
                    modal_form.html(data.message);
                    $('#modal').modal('hide');
                    ezajaxrelationsSearchAddObject(this, $('#ezobjectrelationlist_browse_{/literal}{$attribute.id}{literal}').find('table'), data.content.metadata.id, data.content.metadata.name['ita-IT'], data.content.metadata.class, data.content.metadata.sectionIdentifier, data.content.metadata.published);
                }
            });
            e.preventDefault();
        });

        // apre la finestra modale prima di caricare il form
        $.opendataFormSetup({
            onBeforeCreate: function(){
                $('#modal').modal('show');
            }
        });

    });
    {/literal}

</script>