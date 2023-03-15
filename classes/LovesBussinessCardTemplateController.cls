public with sharing class LovesBussinessCardTemplateController {
    
   /* public Job__c Job{get;set;}
    public Map<string, string> SpecsMap{get;set;}
    public string BachOptionId{get;set;}
    public String jobId{get;set;}
    
    public LovesBussinessCardTemplateController(ApexPages.StandardController controller) {
       jobId = ApexPages.currentPage().getParameters().get('jobid');
       Job = [select id, (select id, Name, Description__c  from Job_Specs__r) from Job__c where id=:jobId WITH SECURITY_ENFORCED ];
       SpecsMap =new Map<string, string>();
       for(Job_Spec__c spec : Job.Job_Specs__r){
           String D;
           if(spec.Description__c == 'Enter Spec Description here'){
               D = '';
           }
           else{
               D = spec.Description__c;
           }
           SpecsMap.put(spec.Name, D);
       }
       
       string backOption = 'BackOptionImage';
       List<Attachment> attachedFiles = [select Id from Attachment where parentId =:jobId and name=:backOption limit 1];
       if(attachedFiles.size() == 1){
           BachOptionId = attachedFiles[0].id;
       }
       else{
           BachOptionId = 'none';
       }
    }*/

}