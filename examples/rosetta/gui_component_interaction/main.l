import forms.
import extensions.

class Window
{
    object form.
    object btmIncrement.
    object btmRandom.
    object txtNumber.
    
    constructor new
    [        
        form := SDIDialog new.
        btmIncrement := Button new.
        btmRandom    := Button new.
        txtNumber    := Edit new.
        
        form controls;
                append:btmIncrement;
                append:btmRandom;
                append:txtNumber.
    
        form set caption:"Rosseta Code".
        form set x:100 y:100.
        form set width:160 height:120.
        
        txtNumber set x:7 y:7.
        txtNumber set width:140 height:25.
        txtNumber set caption:"0".
        
        btmIncrement set x:7 y:35.
        btmIncrement set width:140 height:25.
        btmIncrement set caption:"Increment".
        btmIncrement set onClick: (:args)
            [ $self $onButtonIncrementClick ].
            
        btmRandom set x:7 y:65.
        btmRandom set width:140 height:25.
        btmRandom set caption:"Random".
        btmRandom set onClick: (:args)
            [ $self $onButtonRandomClick ]
    ]
    
    $onButtonIncrementClick
    [
        var number := txtNumber value; toInt.
        
        number := number + 1.   
        $self $changeTextBoxValue:number.
    ]
    
    $onButtonRandomClick
    [
        if(messageDialog open caption:"Inf" question:"Really reset to random value?")
        [
            $self $changeTextBoxValue:(randomGenerator eval:99999999)
        ]
    ]
    
    $changeTextBoxValue : number
    [
        txtNumber set caption:(number literal).
    ]
    
    dispatch => form.
}