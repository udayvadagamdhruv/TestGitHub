public with sharing class EditSpecificationTemplateSwitchExt {

  public string creativeBriefid {set;get;}
    public EditSpecificationTemplateSwitchExt(ApexPages.StandardController controller) {
    
    creativeBriefid =controller.getrecord().id;

    }

}