var SlideItMoo=new Class({
    initialize:function(options){
        this.options=$extend({
            itemsVisible:3,
            showControls:1,
            autoSlide:0,
            transition:Fx.Transitions.linear,
            currentElement:0,
            thumbsContainer:'thumbs',
            elementScrolled:'thumb_container',
            overallContainer:'gallery_container'
        },options||{});
        this.images=$(this.options.thumbsContainer).getElements('a');
        this.image_size=this.images[0].getSize();
        this.setContainersSize();
        this.myFx=new Fx.Scroll(this.options.elementScrolled,{
            transition:this.options.transition
            });
        if(this.images.length>this.options.itemsVisible){
            this.fwd=this.addControlers('addfwd');
            this.bkwd=this.addControlers('addbkwd');
            this.forward();
            this.backward();
            if(!this.options.autoSlide){
                $(this.options.thumbsContainer).addEvent('mousewheel',function(ev){
                    new Event(ev).stop();
                    ev.wheel<0?this.fwd.fireEvent('click'):this.bkwd.fireEvent('click');
                }.bind(this));
            }
            else{
                this.startIt=function(){
                    this.fwd.fireEvent('click')
                    }.bind(this);
                this.autoSlide=this.startIt.periodical(this.options.autoSlide,this);
                this.images.addEvents({
                    'mouseover':function(){
                        $clear(this.autoSlide);
                    }.bind(this),
                    'mouseout':function(){
                        this.autoSlide=this.startIt.periodical(this.options.autoSlide,this);
                    }.bind(this)
                    })
                }
            };

    if(this.options.currentElement!==0){
        this.options.currentElement-=1;
        this.slide(1);
    }
},
setContainersSize:function(){
    $(this.options.overallContainer).set({
        styles:{
            'width':835
        }
    });
$(this.options.elementScrolled).set({
    styles:{
        'width':765
    }
});
},
forward:function(){
    this.fwd.addEvent('click',function(){
        this.slide(1);
    }.bind(this));
},
backward:function(){
    this.bkwd.addEvent('click',function(){
        this.slide(-1);
    }.bind(this))
    },
addControlers:function(cssClass){
    element=new Element('div',{
        'class':cssClass,
        styles:{
            'display':this.options.showControls?'':'none'
            }
        }).injectInside($(this.options.overallContainer));
return element;
},
slide:function(step){
    if(this.options.autoSlide&&this.options.currentElement>=this.images.length-this.options.itemsVisible){
        this.options.currentElement=-1;
    }
    if((this.options.currentElement<this.images.length-this.options.itemsVisible&&step>0)||(step<0&&this.options.currentElement!==0)){
        this.myFx.cancel();
        this.options.currentElement+=step;
        this.myFx.toElement(this.images[this.options.currentElement]);
    }
}
})
