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

  <div class="ezobject-relation-container">
    {if is_set( $attribute.class_content.default_placement.node_id )}
     {set browse_object_start_node = $attribute.class_content.default_placement.node_id}
    {/if}

    {if $browse_object_start_node}
      <input type="hidden" name="{$attribute_base}_browse_for_object_start_node[{$attribute.id}]" value="{$browse_object_start_node|wash}" />
    {/if}

    {if is_set( $attribute.class_content.class_constraint_list[0] )}
      <input type="hidden" name="{$attribute_base}_browse_for_object_class_constraint_list[{$attribute.id}]" value="{$attribute.class_content.class_constraint_list|implode(',')}" />
    {/if}
    
    <div class="table-responsive">
      <table class="table table-condensed" cellspacing="0">
      <thead>
      <tr class="{if $attribute.content.relation_list|not()}hide{/if}">
          <th class="tight"></th>
          <th><small>{'Name'|i18n( 'design/standard/content/datatype' )}</small></th>
          <th><small>{'Section'|i18n( 'design/standard/content/datatype' )}</small></th>            
          <th class="tight"><small>{'Order'|i18n( 'design/standard/content/datatype' )}</small></th>
      </tr>
      </thead>
      <tbody>
        {if $attribute.content.relation_list}
          {foreach $attribute.content.relation_list as $item sequence array( 'bglight', 'bgdark' ) as $style}
		       {def $related = fetch( content, object, hash( object_id, $item.contentobject_id ))}
           <tr>
              {* Remove. *}
              <td class="related-id">
                <input type="checkbox" name="{$attribute_base}_selection[{$attribute.id}][]" value="{$related.id|wash}" />
                <input type="hidden" name="{$attribute_base}_data_object_relation_list_{$attribute.id}[]" value="{$related.id|wash}" />
              </td>
              
              <td class="related-name">
              {if $related|has_attribute( 'image' )}
                {attribute_view_gui attribute=$related|attribute( 'image' ) image_class=tiny fluid=false()}
              {/if}
              {$related.name|wash()} <small>({$related.class_name|wash()})</small>
              </td>

              {* Section *}
              <td class="related-section">
                <small>{fetch( section, object, hash( section_id, $related.section_id ) ).name|wash()}</small>
              </td>
              
              {* Order. *}
              <td class="related-order">
                <input size="2" type="text" name="{$attribute_base}_priority[{$attribute.id}][]" value="{$item.priority}" />
              </td>
          {undef $related}  
          </tr>            
          {/foreach}
        {/if}        
        <tr class="buttons">
          <td colspan="4">
            <button class="btn btn-sm btn-danger ezobject-relation-remove-button {if $attribute.content.relation_list|not()}hide{/if}" type="submit" name="CustomActionButton[{$attribute.id}_remove_objects]">
              <span class="fa fa-trash"></span>
            </button>
            <button class="btn btn-sm btn-info ezobject-relation-add-button pull-right"                 
                type="submit" 
                name="CustomActionButton[{$attribute.id}_browse_objects]">
              <span class="fa fa-plus"></span> {'Add existing objects'|i18n( 'design/standard/content/datatype' )}
            </button>
          </td>          
        </tr>
      </tbody>
      </table>
      <div class="ezobject-relation-browse"           
           data-attribute_base="{$attribute_base}" 
           data-attribute="{$attribute.id}" 
           data-classes="{if is_set( $attribute.class_content.class_constraint_list[0] )}{$attribute.class_content.class_constraint_list|implode(',')}{/if}"
           data-subtree="{if $browse_object_start_node}{$browse_object_start_node|wash}{/if}"></div>

    </div>
  </div>  
{/if}

</fieldset>

{/default}
{/let}
