Global class JobsuiteEmailProcessForJob implements Messaging.InboundEmailHandler
{
        Public String user;
        Global Messaging.InboundEmailResult handleInboundEmail(Messaging.InboundEmail email, Messaging.Inboundenvelope envelope)
        {
        
            /*string no=Job__c.SobjectType.getDescribe().getKeyPrefix();
            system.debug('Prefix'+no);
            Messaging.InboundEmailResult result=new Messaging.InboundEmailresult();
            list<Attachment> attachs=new list<Attachment>();
            string emailaddress=email.FromAddress;
            
            user = userinfo.getusername();
            
            
          if(email.binaryAttachments!=null) { 
          
            for(Messaging.InboundEmail.binaryAttachment file:email.binaryAttachments)
              {
                    Task t=new Task();
                    Attachment attch=new Attachment();
                    String str =email.subject; 
                    Pattern idPattern = Pattern.compile(no+'[A-Za-z0-9]{12}');
                    Matcher matcher = idPattern.matcher(str);
                    if (!matcher.find()) System.assert(false, 'No Job Id in subject!');
        
                    Job__c b= [SELECT id,Name FROM Job__c WHERE Id = :matcher.group(0)];
                  
                    t.whatid=B.ID;
                    t.subject=str ;
                    t.Description=email.plainTextBody;
                    t.status='Completed';
                    t.Email_address__c=user ;
                    t.sender_address__C = emailaddress;
                    insert t;
                
                
                        attch.parentId=t.id;
                        attch.Name=file.fileName;
                        attch.body=file.body;
                        attachs.add(attch);
                }
              
             }
              
             else{
             
                    Task t=new Task();
                    Attachment attch=new Attachment();
                    String str =email.subject; 
                    Pattern idPattern = Pattern.compile(no+'[A-Za-z0-9]{12}');
                    Matcher matcher = idPattern.matcher(str);
                    if (!matcher.find()) System.assert(false, 'No Job Id in subject!');
        
                    Job__c b= [SELECT id,Name FROM Job__c WHERE Id = :matcher.group(0)];
                      
                        t.whatid=B.ID;
                        t.subject=str ;
                        t.Description=email.plainTextBody;
                        t.status='Completed';
                        t.Email_address__c=user ;
                        t.sender_address__C = emailaddress;
                        insert t;
                       
                      
                      
              }
              
              
            if(attachs.size()>0){
                insert attachs;
            }
            
        return null;
        
        }*/
             return null;
}










/*global class BudgetUpdateEmailHandler implements Messaging.InboundEmailHandler {
  global Messaging.InboundEmailResult handleInboundEmail(
  Messaging.InboundEmail email,
  Messaging.InboundEnvelope envelope)
  {
    String subject = email.subject;
    String body=email.body;
    Pattern idPattern = Pattern.compile('a0Q[A-Za-z0-9]{12}');
    Matcher matcher = idPattern.matcher(subject);
    if (!matcher.find()) System.assert(false, 'No Budget Id in subject!');

    Budget__c b= [SELECT Name FROM Budget__c WHERE Id = :matcher.group(0)];
    b.Name =' cool dude demo';
    update b;

    /*Messaging.InboundEmailresult result = new Messaging.InboundEmailResult();
    result.message = 'Budget Name is now ' + Budget__c.Name;
    return result;
    return null;
  }*/
   
}