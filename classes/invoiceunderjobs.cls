public class invoiceunderjobs
{
    @AuraEnabled
    public static List<	Job__c> getJobs(Integer recordLimit, Integer recordOffset){
        Integer intLimit = Integer.valueof(recordLimit);
        Integer intOffset = Integer.valueof(recordOffset);
        List<Job__c>joblist=[Select id,name,Schedule_Calc__c,marked_Done__c,Status__c,JS_Client__c,JS_Client_Contact__c,Job_Auto_Number__c,Completion_Date__c from Job__c  where Status__c ='Completed' and Completion_Date__c =LAST_N_DAYS:90 order by Completion_Date__c desc  LIMIT :intLimit Offset :intOffset];
        //List<Job__c>joblist=[Select id,name,Schedule_Calc__c,marked_Done__c,Status__c,JS_Client__c,JS_Client_Contact__c,Job_Auto_Number__c,Completion_Date__c from Job__c  where Status__c ='Completed' and Completion_Date__c =LAST_N_DAYS:90 order by Completion_Date__c desc  LIMIT :intLimit Offset :intOffset];
         system.debug('Total job records==='+joblist.size());
        return joblist;
    }
    
    //Get Total Number of Contacts
    @AuraEnabled
    public static Integer getTotalrcds(){
        List<Job__c>results = [Select Id, Name, Status__c from Job__c  where Status__c  = 'Completed' and Completion_Date__c =LAST_N_DAYS:90];
        system.debug('Total records==='+results.size());
        return results.size();
    } 
    
    @AuraEnabled
    public static void createclientinvoices(list<Job__c>selectedjobs)
    {
        // system.debug('The selected jobs are '+selectedjobs);
        list<job__c> jqj = selectedjobs;
        system.debug('The selected jobs size=============='+jqj.size());
        list<Client_Invoice__c>clientinvce = new list<Client_Invoice__c>();
        set<string>jobids = new set<string>();
        set<string>clientids = new set<string>();
        map<string,Estimate_Line_Items__c> estln = new map<string,Estimate_Line_Items__c>();
        map<string,list<Estimate_Line_Items__c>> estln2 = new map<string,list<Estimate_Line_Items__c>>();
        map<string,Client_Invoice__c> clin = new map<string,Client_Invoice__c>();
        map<string,list<Client_Invoice__c>> clin2 = new map<string,list<Client_Invoice__c>>();
        list<Client_Invoice_Line_Item__c> cientlineitemsref = new list<Client_Invoice_Line_Item__c>();
        list<Estimate_Line_Items__c> estimateslineitems = new  list<Estimate_Line_Items__c>();
        for(Job__c jj : selectedjobs)
        {
            jobids.add(jj.id);
        }
        for(Job__c jj : [Select id,name,JS_Client__c,(select id,name,Unit_Type__c, Amount__c, Total_Amount__c, Job__c, Job__r.JS_Client__c,Approved__c,GL_Department__c,GL_Code__c,Vendor__c,Quantity__c from Estimate__r where  Approved__c=true) from Job__c  where id= : jobids])
        {
            Client_Invoice__c cinvice = new Client_Invoice__c();
            cinvice.Client_Name__c = jj.JS_Client__c;
            cinvice.Job__c = jj.id;
            cinvice.Invoice_Date__c = system.today();
            cinvice.Invoice_Status__c = 'Open';
            clientinvce.add(cinvice);
            clientids.add(jj.JS_Client__c);
            if(!clin.containsKey(jj.id))
            {
                clin.put(jj.id,cinvice);
                system.debug('the inserted client invoice=== '+clin);
            }
            for(Estimate_Line_Items__c ccln : jj.Estimate__r )
            {
                estimateslineitems.add(ccln);
                // estln2.put(ccln.Job__c,estimateslineitems);         
                system.debug('The size '+estimateslineitems.size()+'The estimated record is '+estimateslineitems+'\n');
            }
        }
        system.debug('client invoices size======'+clin.values().size());
        if(clin.size()>0)
        {
            insert clin.values();
        }
        for(Estimate_Line_Items__c cln : estimateslineitems)
        {
            if(clin.containskey(cln.job__c)) 
            {
                Client_Invoice__c clientinvs = clin.get(cln.job__c);
                system.debug('client inv record is '+clientinvs.id + 'job id is '+cln.job__c);
                Client_Invoice_Line_Item__c  ciln = new Client_Invoice_Line_Item__c();
                ciln.Client_Invoice__c = clientinvs.id;
                ciln.GL_Code__c = cln.GL_Code__c;
                ciln.Estimate_Line_Item__c = cln.id;
                ciln.Quantity__c = cln.Quantity__c;
                cientlineitemsref.add(ciln);   
            }
        }
        system.debug('The inserted line items are '+cientlineitemsref+'\n');
        system.debug('The inserted line items size====== '+cientlineitemsref.size());
        if(cientlineitemsref.size()>0)
        {
            insert cientlineitemsref;
        }
    }
    
    /*@AuraEnabled
public static void createclientinvoices(list<Job__c>selectedjobs)
{
// system.debug('The selected jobs are '+selectedjobs);
list<Client_Invoice__c>clientinvce = new list<Client_Invoice__c>();
set<string>clientids = new set<string>();
map<string,Estimate_Line_Items__c> estln = new map<string,Estimate_Line_Items__c>();
map<string,Client_Invoice__c> clin = new map<string,Client_Invoice__c>();
for(Job__c j : selectedjobs)
{
// system.debug('The  jobs are '+j);
Client_Invoice__c cinvice = new Client_Invoice__c();
cinvice.Client_Name__c = j.JS_Client__c;
cinvice.Job__c = j.id;
cinvice.Invoice_Date__c = system.today();
cinvice.Invoice_Status__c = 'Open';
clientinvce.add(cinvice);
clientids.add(j.JS_Client__c);
clientids.add(j.id);
}
//  system.debug('the clientinvce=== '+clientinvce.size());
if(clientinvce.size()>0)
{
insert clientinvce;
}
list<Estimate_Line_Items__c> estimateslineitems = [select id,name,Unit_Type__c, Amount__c, Total_Amount__c, Job__c, Job__r.JS_Client__c,Approved__c,GL_Department__c,GL_Code__c,Vendor__c,Quantity__c from Estimate_Line_Items__c where Job__c =:clientids and Job__r.JS_Client__c =: clientids and  Approved__c =true];
list<Client_Invoice__c>clntinv = [Select id,Client_Name__c,Invoice_Total__c,Total_Allocated_Qty__c,Job__c  from Client_Invoice__c  where job__c =:clientids];  
for(Client_Invoice__c cln : clntinv)
{
clin.put(cln.Job__c,cln);
system.debug('the clientinvoice=== '+clin);
}
list<Client_Invoice_Line_Item__c> cientlineitemsref = new list<Client_Invoice_Line_Item__c>();
for(Estimate_Line_Items__c cln : estimateslineitems)
{
system.debug('The estimated record is '+cln);
system.debug('The key record is '+clin.containskey(cln.job__c));
if(clin.containskey(cln.job__c))
{
Client_Invoice__c clientinvs = clin.get(cln.job__c);
system.debug('client inv record is '+clientinvs.id + 'job id is '+cln.job__c);
Client_Invoice_Line_Item__c  ciln = new Client_Invoice_Line_Item__c();
ciln.Client_Invoice__c = clientinvs.id;
ciln.GL_Code__c = cln.GL_Code__c;
ciln.Estimate_Line_Item__c = cln.id;
ciln.Quantity__c = cln.Quantity__c;
cientlineitemsref.add(ciln);
}
}
system.debug('The inserted line items are '+cientlineitemsref);
system.debug('The inserted line items size====== '+cientlineitemsref.size());
if(cientlineitemsref.size()>0)
{
insert cientlineitemsref;
}
}*/
}