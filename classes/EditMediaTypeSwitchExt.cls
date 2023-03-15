public with sharing class EditMediaTypeSwitchExt
{
    public string MediatypeId{get;set;}
    public EditMediaTypeSwitchExt(ApexPages.StandardController controller) 
    {
        MediatypeId= controller.getRecord().id;
    }

}