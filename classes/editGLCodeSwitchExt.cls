public with sharing class editGLCodeSwitchExt
{
    public string GLCodeId{get;set;}
    public editGLCodeSwitchExt(ApexPages.StandardController controller) 
    {
        GLCodeId= controller.getRecord().id;
    }

}