public class integratedjobrcds {
    
    public static TaskWrapper getAsanaTask(Job__c jobrec,map<String,String> assanaCustFields, boolean isupdate){
        TaskWrapper twp = new TaskWrapper();
        twp.data = new AssanaTask();
        twp.data.name = jobrec.Name;
        twp.data.due_on=jobrec.Due_Date__c;
        if(!isupdate){
            twp.data.projects = new List<String>();
            twp.data.projects.add('1201746669791009'); 
        }
        twp.data.custom_fields = new Map<String,Object>();
        if(assanaCustFields.size()>0){
            for(String s : assanaCustFields.keyset()){
                String originalString = s.removeEnd('__c');
                originalString = originalString.split('_')[originalString.split('_').size()-1];
                if(jobrec.get(s)!=null){
                    if(assanaCustFields.get(s) == 'MULTIPICKLIST'){
                        string l = string.valueof(jobrec.get(s));
                        twp.data.custom_fields.put(originalString,l.split(';')); 
                    }  
                    else{
                        twp.data.custom_fields.put(originalString,jobrec.get(s));
                    }
                }
            }
        }
        
        return twp;
    }
    
    @future(callout=true)
    public static Void createOrUpdateTaskRecordsinAsana(List<Id>idList, String method){
        Map<String, Schema.SObjectField> fieldList = idList[0].getSObjectType().getDescribe().fields.getMap();
        // Asana_Creds__c ac = Asana_Creds__c.getInstance('Assana Account');
        list<Asana_Creds__c> ac = Asana_Creds__c.getall().values();
        if(ac.size() > 0){
            if(ac[0].Name != null && ac[0].Name == 'Assana Account')
            {
                string rcdid = idList[0];
                String query='SELECT ';
                map<String,String> assanaCustFields = new map<String,String>();
                for(String s : fieldList.keyset()){
                    query+=s+', ';
                    if(s.contains('acf_')) assanaCustFields.put(s,string.valueof(fieldlist.get(s).getDescribe().getType()));
                }
                query = query.removeEnd(', ');
                
                query+=' from Job__c where id =:rcdid LIMIT 1';
                //   String query='SELECT id,Name,Assana_ExtenalId__c,Due_Date__c,Next_Tasks_Due__c  from Job__c where id =:idList[0] LIMIT 1';
                //system.debug('Query === '+query);
                Job__c jobrec= Database.query(query);
                TaskWrapper task = getAsanaTask(jobrec,assanaCustFields, method == 'PUT');
                Http h = new Http();
                HttpRequest req = new HttpRequest();
                req.setMethod(method);
                if(method == 'PUT')req.setBody(JSON.serialize(task,true));
                else req.setBody(JSON.serialize(task));
                req.setHeader('Authorization','Bearer '+ac[0].Access_Token__c);
                req.setHeader('Content-Type','application/json');
                req.setHeader('Accept','application/json');
                req.setTimeout(120000);
                String endpoint ='https://app.asana.com/api/1.0/tasks';
                if(method == 'PUT') endpoint+='/'+jobrec.Assana_ExtenalId__c;
                req.setEndpoint(endpoint);
                HttpResponse res = h.send(req);
                if((res.getStatusCode()==201 || res.getStatusCode()==200) && method !='PUT'){
                    TaskWrapperresp tskwrap = (TaskWrapperresp)JSOn.deserialize(res.getBody(), TaskWrapperresp.class) ;
                    jobrec.Assana_ExtenalId__c=tskwrap.data.gid;
                    update jobrec;
                }
            }
        }
    }
    
    public class TaskWrapper{
        public AssanaTask data;
    }
    public class AssanaTask{
        public String name;
        public String gid;
        public date due_on;
        public date start_on;
        public Map<String,Object> custom_fields;
        public List<string> projects;
    }
    public class TaskWrapperresp{
        public AssanaTaskresp data;
    }
    public class AssanaTaskresp{
        public String gid;
    }
}