<?php

class OCOpendataFormDesignOperators
{
    const RELATION_CONTAINER_REMOTE_ID = 'opendata_forms_relations_container';

    function operatorList()
    {
        return array(
            'default_relations_parent_node_id'
        );
    }

    function namedParameterPerOperator()
    {
        return false;
    }

    function namedParameterList()
    {
        return array();
    }

    function modify(
        &$tpl,
        &$operatorName,
        &$operatorParameters,
        &$rootNamespace,
        &$currentNamespace,
        &$operatorValue,
        &$namedParameters
    ) {

        switch ($operatorName) {
            case 'default_relations_parent_node_id': {
                $operatorValue = $this->getRelationsDefaultParentNodeId();
            }
                break;
        }
    }

    private function getRelationsDefaultParentNodeId()
    {
        $object = eZContentObject::fetchByRemoteID(self::RELATION_CONTAINER_REMOTE_ID);
        if(!$object instanceof eZContentObject){
            $object = eZContentFunctions::createAndPublishObject(array(
                'class_identifier' => 'folder',
                'remote_id' => self::RELATION_CONTAINER_REMOTE_ID,
                'parent_node_id' => 1,
                'attributes' => array(
                    'name' => 'Contenuti correlati'
                )
            ));
        }
        if(!$object instanceof eZContentObject){
            eZDebug::writeError("Relations Default Parent Object not found");
            return null;
        }

        return $object->attribute('main_node_id');
    }

}
