import { LightningElement } from 'lwc';
import FORM_FACTOR from "@salesforce/client/formFactor";
import getContacts from '@salesforce/apex/Controller.getContacts';

export default class LifecycleHooks extends LightningElement {

    //Constructor
    //Connectedcallback
    //RenderedCallback
    //Render
    //DisconncectedCallback

    name;
    contacts=[];

    LifecycleHooks(){
        console.log('constructor executed');
    }

    get isContactsAvailable(){
        if(this.contacts.length>0){
            return true;
        }else{
            return false;
        }
    }

    connectedCallback(){
        console.log('connectedCallback executed');
        this.handleFormFactor();

    }

    renderedCallback(){
        console.log('renderedCallback executed');
        if(this.name=='Sarang'){
            console.log('Match');
        }

    }

    handleFormFactor() {
        if (FORM_FACTOR === "Large") {
            this.deviceType = "Desktop/Laptop";
        } else if (FORM_FACTOR === "Medium") {
            this.deviceType = "Tablet";
        } else if (FORM_FACTOR === "Small") {
            this.deviceType = "Mobile";
        }

        console.log(this.deviceType);
    }

    disconnectedCallback(){
        console.log('disconnectedCallback executed');
    }

    handleNameChange(event){
        this.name=event.target.value;

       if(this.name.length>2){
         this.fetchContacts();
       }
       
    }

    handleOnclick(event){
        console.log('search clicked');
        this.fetchContacts();
     
    }

    fetchContacts(){
         getContacts({firstName:this.name}).then(result =>{
            console.log(JSON.stringify(result));
            this.contacts=result;

        }).catch(error=>{
            console.log(JSON.stringify(error));
        })
    }
   
}