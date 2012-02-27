package typography {	import org.papervision3d.core.proto.GeometryObject3D;	import org.papervision3d.objects.DisplayObject3D;		import special.VectorShapeMaterial;		/**	 * @author Mark Barcinski	 */	public class Word3D extends DisplayObject3D {		public var letters : Array;		public var spacing : Number = 0;		public var word : String;		public var font : Font3D;					public function Word3D(word:String , font : Font3D , material:VectorShapeMaterial, 								name : String = null, geometry : GeometryObject3D = null ) {			super(name, geometry);						this.material = material;			this.font = font;			this.word = word;						letters = [];			setupLetterWord(material);		}				private function setupLetterWord(material:VectorShapeMaterial) : Array 		{			var letter : Letter3D;			var prevLetter : Letter3D;						for(var i:int = 0 ; i < word.length ; i++)			{				var char:String = word.charAt(i);				letter = new Letter3D(char, material , font );				letters.push(letter); 								if(i > 0){					letter.x = prevLetter.x + (prevLetter.width/2 + letter.width/2)  + spacing ;				}				addChild(letter);					prevLetter = letter;			}						//center it a litlle			var tx : Number = (prevLetter.x + prevLetter.width ) / 2;			for(i = 0 ; i < word.length ; i++)			{				Letter3D(letters[i]).x -= tx;					}						return letters;		}	}}