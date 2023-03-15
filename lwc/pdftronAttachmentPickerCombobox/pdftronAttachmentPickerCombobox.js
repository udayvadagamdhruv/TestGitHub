import { LightningElement, track, wire, api } from 'lwc';
import { CurrentPageReference } from 'lightning/navigation';
import { fireEvent } from 'c/pubsub';
import { registerListener, unregisterAllListeners } from 'c/pubsub';
import getAttachments from "@salesforce/apex/PDFTron_ContentVersionController.getAttachments";
import getAttachmentBody from "@salesforce/apex/PDFTron_ContentVersionController.getAttachmentBody";
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { refreshApex } from '@salesforce/apex';
//import getAttachments1 from "@salesforce/apex/PDFTron_ContentVersionController.getAttachments1";


export default class PdftronAttachmentPickerCombobox extends LightningElement {
    error;

    @track value = '';
    @track picklistOptions = [];
    @track isSaving = false;
    @track loadFinished = false;
    @track dataloadFinished = false;
    @api recordId;
    @wire(CurrentPageReference) pageRef;
    @track currenRecordId;
   // @track refreshFile=false;

    wiredDataResult;
    @wire(getAttachments, {recordId: "$recordId"}) 
    attachments(result) {
        this.wiredDataResult = result;
        this.picklistOptions = '';
   // attachments({error, data}) {
        if(result.data) {
          //  this.refreshFile=true;
            result.data.forEach((attachmentRecord) => {
                console.log('>>>>>>>>>>>Attachment',JSON.stringify(attachmentRecord));
                var name = attachmentRecord.cv.Title + "." + attachmentRecord.cv.FileExtension;
                var Id = attachmentRecord.cv.ContentDocumentId;
                const option = {
                    label: name,
                    value: Id
                };
                console.log('>>>>>>>>>>>Option',JSON.stringify(option));
                this.picklistOptions = [ ...this.picklistOptions, option ];
            });
            
            this.error = undefined;
            this.loadFinished = true;
        } else if (result.error) {
            console.error(result.error);
            this.error = result.error;
            this.picklistOptions = undefined;
            let def_message = 'We have encountered an error while loading up your document. '

            this.showNotification('Error', def_message + error.body.message, 'error');
        }
    };
    _listenForMessage;
    connectedCallback() {
       // console.log('>>>>>>>Combobox connectedCallback>>>>>>>>');
        this.changeFilter();
        registerListener('fileNameRefresh', this.handlefileNameRefresh, this);
    }

    disconnectedCallback() {
        unregisterAllListeners(this);
    }

    handlefileNameRefresh(){
       // this.changeFilter();
       let filterKeyValuee;
       let filterBoxe = this.template.querySelector("lightning-combobox");
       filterKeyValuee = filterBoxe.value;
       console.log('>>>>>>>handlefileNameRefresh filterKeyValue>>>>>>>>>>>>',filterKeyValuee);
       console.log('>>>>>>> handlefileNameRefresh ');
       getAttachments({recordId: this.recordId})
           .then(result => {
               refreshApex(this.wiredDataResult);
               this.error = undefined;
               this.loadFinished = true;
               this.value=filterKeyValuee;
           })
           .catch(error => {
          //     console.log('>>>>>>> Combobox changeFilter error');
               this.error = error;
               this.picklistOptions = undefined;
               let def_message = 'We have encountered an error while loading up your document. '
               this.showNotification('Error', def_message + error.body.message, 'error');
           });



    }

    changeFilter(){
        console.log('>>>>>>> Combobox changeFilter');
        getAttachments({recordId: this.recordId})
            .then(result => {
                refreshApex(this.wiredDataResult);
                this.error = undefined;
                this.loadFinished = true;
            })
            .catch(error => {
           //     console.log('>>>>>>> Combobox changeFilter error');
                this.error = error;
                this.picklistOptions = undefined;
                let def_message = 'We have encountered an error while loading up your document. '
                this.showNotification('Error', def_message + error.body.message, 'error');
            });
    }
   

    showNotification(title, message, variant) {
        const evt = new ShowToastEvent({
            title: title,
            message: message,
            variant: variant,
        });
        this.dispatchEvent(evt);
    }

    @track data = '';
    @track error;
    @track nrecVal = '';
    @track recVal = '';
    @track ChangeloadFinished = false;
    
    refreshComponent(event){
       this.ChangeloadFinished = true;
       refreshApex(this.wiredDataResult);
       //this.ChangeloadFinished = false;

       //this.selectedVal=event.detail.value;
       console.log('>>>>>>>refreshComponent>>>>>>>>>>>>');
       console.log('>>>>>>>refreshComponent event.detail.value>>>>>>>>>>>>',event.detail.value);
       //console.log('>>>>>>>refreshComponent this.refreshFile>>>>>>>>>>>>',this.refreshFile);
       let filterKeyValue;
      /*if(this.refreshFile){
        filterKeyValue='';
      }else{*/
        let filterBox = this.template.querySelector("lightning-combobox");
         filterKeyValue = filterBox.value;
        console.log('>>>>>>>refreshComponent filterKeyValue>>>>>>>>>>>>',filterKeyValue);
      //}
        
       
       getAttachmentBody({recordId: filterKeyValue}).then(result => {
        this.ChangeloadFinished = true;
           this.data = result[0];
           this.error = undefined;
           this.dataloadFinished = true;
           this.ChangeloadFinished = false;
           this.recVal = JSON.stringify(JSON.parse(JSON.stringify(this.data)));
           
       //this.recVal = this.nrecVal.toString();

       console.log('>>>>>>>> refreshComponent Result >>>>>>>>>>>>>>>>>>>>>>',JSON.stringify(this.recVal));
       
       fireEvent(this.pageRef, 'blobSelected', this.recVal);
         
       })
       .catch(error => {
           console.log('>>>>>>>>>>>>>>>>Error onchange>>>>>>>>>>>>>>>>>>>>>');
            this.ChangeloadFinished = false;
            this.error = error;
       });

    }

   /* handlefocus(){
        fireEvent(this.pageRef, 'onchangesavealt', this.recVal);
    }*/


  // @track casesSpinner = false;
  @track selectedVal;
    handleChange(event) {
            this.ChangeloadFinished = true;
           // console.log('>>>>>>>> Handle Change ID val>>>>>>>>>>>>>>>>>>>>>>',event.detail.value);
           this.selectedVal=event.detail.value;
            getAttachmentBody({recordId: event.detail.value}).then(result => {
                this.data = result[0];
                this.error = undefined;
                this.dataloadFinished = true;

                this.recVal = JSON.stringify(JSON.parse(JSON.stringify(this.data)));
                this.ChangeloadFinished = false;
            //this.recVal = this.nrecVal.toString();

            //console.log('>>>>>>>> Handle Change Return result lll  11>>>>>>>>>>>>>>>>>>>>>>',JSON.stringify(this.recVal));
            
            fireEvent(this.pageRef, 'blobSelected', this.recVal);
              
            })
            .catch(error => {
                console.log('>>>>>>>>>>>>>>>>Error onchange>>>>>>>>>>>>>>>>>>>>>');
                this.ChangeloadFinished = false;
               /* this.error = error;
                let def_message = 'Selected File has been deleted '
                this.showNotification('Error', def_message + error, 'error');*/

                const evt = new ShowToastEvent({
                    title: 'Warning',
                    message: 'Selected file has removed from the database. Please click on refresh button on the layout.',
                    variant: 'error',
                    mode: 'dismissable'
                  });
                  this.dispatchEvent(evt);

            });
            
    }

    submitDetails() {
        this.isSaving = true;
        this.saveData();
    }

    saveData() {
        //saves current file
        const data = new FormData();
        data.append('mydoc.pdf', blob, 'mydoc.pdf');
    }
}