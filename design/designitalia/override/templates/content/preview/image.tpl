{foreach $object.data_map as $attribute}
  {if $attribute.data_type_string|eq('ezimage')}
  <div class="well well-sm">
	<p class="text-center">{attribute_view_gui attribute=$attribute image_class=large alignment=center}</p>
	{def $keys = array('width','height','mime_type','filename','alternative_text','url','filesize')}
	<table class="table">
		{foreach $attribute.content.original as $name => $value}
			{if $keys|contains($name)}
			<tr>
				<td>{$name}</td>
				<td>
				  {if $name|eq('url')}
					  <a target="_blank" href={$value|ezroot()}>{$value|wash()}</a>
				  {elseif $name|eq('filesize')}
					  {$value|si(byte)}
				  {else}
					  {$value|wash()}
				  {/if}
				</td>
			</tr>
			{/if}
		{/foreach}
	</table>
  </div>
  {/if}
{/foreach}

<table class="table">
  {foreach $object.data_map as $attribute}
	  
	{if $attribute.data_type_string|ne('ezimage')}		
	<tr>  
	  <td>{$attribute.contentclass_attribute_name}</td>
	  <td>
        {if array( 'ezstring', 'ezinteger', 'ezkeyword', 'eztext', 'ezobjectrelationlist' )|contains( $attribute.data_type_string )}
        
          {def $inputTag = 'input'}
          {if array( 'eztext' )|contains( $attribute.data_type_string )}
            {set $inputTag = 'textarea'}
          {elseif array( 'ezobjectrelationlist' )|contains( $attribute.data_type_string )}          
            {if $attribute.class_content.selection_type|eq(1)}
              {set $inputTag = 'option:selected'}
            {elseif $attribute.class_content.selection_type|eq(2)}
              {set $inputTag = 'input:checked'}
            {elseif $attribute.class_content.selection_type|eq(3)}
              {set $inputTag = 'input:checked'}
            {else}
              {set $inputTag = 'nullTag'}
            {/if}
          {/if}
        
          <span>
            <a class="inline-edit" data-input="{$inputTag}" data-objectid="{$attribute.object.id}" data-attributeid="{$attribute.id}" data-version="{$attribute.version}"><i class="fa fa-edit"></i></a>
            {attribute_view_gui attribute=$attribute image_class=large}
          </span>
          <span class="inline-form" style="display: none">
            {attribute_edit_gui attribute=$attribute html_class='form-control'}
            <button class="btn btn-danger pull-right">Salva</button>
          </span>
          
          {undef $inputTag}
          
        {else}
          {attribute_view_gui attribute=$attribute image_class=large}
        {/if}
        
      </td>	  
    <tr>
	{/if}
  {/foreach}
</table>
