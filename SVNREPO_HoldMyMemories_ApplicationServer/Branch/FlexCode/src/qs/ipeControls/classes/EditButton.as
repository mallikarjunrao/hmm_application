package qs.ipeControls.classes
{
	import mx.controls.Button;
	import mx.effects.Glow;

	public class EditButton extends Button
	{
		[Embed(source="../../../assets/choosefilesdef.png")]
		private var uploadDefSkin : Class;
		[Embed(source="../../../assets/choosefilesovr.png")]
		private var uploadOvrSkin : Class;
		private var glowEffect : Glow = new Glow();
		public function EditButton()
		{
			super();
			this.setStyle("upSkin", uploadDefSkin);
			this.setStyle("overSkin", uploadOvrSkin);
			this.setStyle("downSkin", uploadDefSkin);
			this.setStyle("disabledSkin", uploadDefSkin);
			this.setStyle("selectedOverSkin", uploadOvrSkin);
			this.setStyle("selectedDownSkin", uploadDefSkin);
			this.setStyle("selectedUpSkin", uploadDefSkin);
			this.setStyle("overEffect", glowEffect);
			
		}
	}
}