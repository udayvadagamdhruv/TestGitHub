public with sharing class LookupSldsCompCtrl {
   /* Public List<SObject> RecordsList{set;get;}
    Public list<string> FieldsToShow{set;get;}
    Public String QueryString{set;get;}
    Public String WhereCondi{set;get;}
    Public String RecordsLimit{set;get;}
    Public string SobjectName{set;get;}
    Public integer size{set;get;}
    Public List<SObject>    Records{set;get;}
    Public string SelectdValue{set;get;}
    Public boolean Hidetable{set;get;}
    Public string Dummystring{set;get;}
    Public Boolean showMsg{set;get;}
   // Public string NewSelectedID {set;get;}
    
    Public LookupSldsCompCtrl(){
        Hidetable=true;
        showMsg=false;
    }     
    
    
    public ApexPages.StandardSetController setLookupComp {
        get{
               
               if(setLookupComp ==null){
               
               FieldsToShow.add('Name');
                String joinFields= String.join(FieldsToShow, ',');
               
               QueryString='Select Id ,'+ joinFields+' from '+SobjectName+' ';
               string wh=WhereCondi;
               system.debug('QueryString:LookupComp'+QueryString );
                ExcuteQuery(QueryString+wh);                
            }

            return setLookupComp ;
        }set;
    }
    
    
    
    
    Public void keyupQuery(){
               FieldsToShow.add('Name');
                String joinFields= String.join(FieldsToShow, ',');
               
               QueryString='Select Id ,'+ joinFields+' from '+SobjectName+' ';
                
            if(string.isNotBlank(SelectdValue) &&SelectdValue!=null ){
                         Dummystring=SelectdValue+'%';  

              string wh=WhereCondi+' AND Name like :Dummystring' ;
            system.debug('QueryString+wh' +QueryString+wh);
            ExcuteQuery(QueryString+wh+' limit '+RecordsLimit);
                        MShowtable();

            }
            else{
            
            ExcuteQuery(QueryString+' '+WhereCondi+' limit '+RecordsLimit);
                        MShowtable();
            //SelectdValue=null;
            }    

    }
    Public void ExcuteQuery(string Queryy){
                try{
                size = 5;
                system.debug('Queryy'+Queryy) ;               
                setLookupComp = new ApexPages.StandardSetController(Database.getQueryLocator(Queryy));
                setLookupComp.setPageSize(size);
                //NoOfRecords= setLookupComp.getResultSize();
                FieldsToShow.remove(FieldsToShow.size()-1);
                }
                catch(exception e){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL,''+e));
                }
    
    
    }
        
    Public list<Sobject> getQueryRecordsList(){
            Records= new list<sobject>();
           
            for(Sobject Obj:(list<sobject>)setLookupComp.getRecords() ){
            Records.add(Obj);
            }            

             return Records;
      
        
    }
    Public integer NoOfRecords{set;get{
        return setLookupComp==null?0:setLookupComp.getResultSize();
    }}

    public void CompFirst() {
        setLookupComp.first();
        system.debug('i am first');
    }

    public void CompLast() {
        setLookupComp.last();
        system.debug('i am Last');

    }

    public void CompPrevious() {
        setLookupComp .previous();
        system.debug('i am Previous');

    }

    public void CompNext() {

        setLookupComp.next();
        system.debug('i am Next');

    }
    
    public Boolean CompHasNext{

        get {
            system.debug('is its exe -->hasnext');

            return setLookupComp==null?false:setLookupComp.getHasNext();
        }
        set;

    }
    
    public Boolean CompHasPrevious{

        get {

            system.debug('is its exe -->hasprevious');
            return setLookupComp==null?false:setLookupComp.getHasPrevious();
        }
        set;
    }    
 Public void MShowtable(){
     Hidetable=false;
     //if(string.isnotblank(SelectdValue)){keyupQuery();}
     
          
 }
  Public void MHidetable(){
     Hidetable=true;
     //  Apexpages.addMessage(New Apexpages.Message(Apexpages.Severity.Error,''+SelectedID));
 }*/
}