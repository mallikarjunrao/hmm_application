package 
{
        import flash.display.*;
        import flash.events.*;
        import flash.text.*;
        
        import mx.utils.ObjectUtil;
        
        import org.papervision3d.materials.MovieMaterial;

        public class TextMaterial extends MovieMaterial {
                public static const DEFAULT_BG_COLOR:int = 0XFFFFFF;
                public static const DEFAULT_FG_COLOR:Number = 0X123456;
                
                private var textField:TextField;
                private var textFormat:TextFormat;
                private var backgroundColor:int = DEFAULT_BG_COLOR;
                private var forgroundColor:int = DEFAULT_FG_COLOR;
                private var fontFamily : String;
                private var size : int;
               /*  [Embed(source="assets/TheNautiGalROB.ttf",
                    fontName="TheNautiGal")]
            public var TheNautiGal:Class;
 */
                public function TextMaterial(value:String, 
fontfamily : String,size : int,field:TextField = null,format:TextFormat = null):void {
                        if(field == null){
                                field = createTextField();
                        }
                        fontFamily = fontfamily;
                        this.size = size;
                        value = "  "+value+"  ";
                    
                        textField = field;

                        this.doubleSided = true;

                        if(format == null){
                                format = createTextFormat();
                        }

                        textFormat = format;
                        textField.text = value;
                        textField.setTextFormat(textFormat);

                        var asset:MovieClip = new MovieClip();
                        asset.addChild(textField);

                        textField.x = 0;
                        textField.y = 0;

                        asset.width = textField.width;
                        asset.height= textField.height;

                        var transparent:Boolean = true;
                        var initObject:Object = {animated:true, doubleSided:true};

                        super(asset, transparent, initObject);
                }

                public function get width() : int { return textField.width; }
                public function get height() : int { return textField.height; }

                public function get text():String{
                        return textField.text;
                }

                public function set text(value:String):void{
                        textField.text = value;
                        super.updateBitmap();
                }

                private function createTextField():TextField {
                        var text:TextField = new TextField();
                        text.autoSize = TextFieldAutoSize.CENTER;
                        text.selectable = false;
                        text.background = false;
                        text.backgroundColor = backgroundColor;
                        text.border = false;
                        //text.borderColor = 0X1234de;
                       // text.textColor = forgroundColor;
                        return text;
                }

                private function createTextFormat():TextFormat {
                        var format:TextFormat = new TextFormat();
                        format.bold = true;
                        format.italic = false;
                        format.size = size;
                        format.color = 0XFFFFFF;
                        format.underline = false;
                        /* if(fontFamily == "TheNautiGal")
                        {
                        	var c : Font = new TheNautiGal();
                        	format.font = ObjectUtil.toString(c);
                        } */
                       /*  else */
                        	format.font = fontFamily;//"TheNautiGal";
                        return format;
                }
        }
} 