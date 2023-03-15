public with sharing class EditProductionSpecItemSwitchExt
{
    public string PESpecId{get;set;}
    public EditProductionSpecItemSwitchExt(ApexPages.StandardController controller) 
    {
        PESpecId = controller.getRecord().id;
    }

}