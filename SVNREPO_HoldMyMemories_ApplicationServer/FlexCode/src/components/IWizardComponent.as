package components
{
	public interface IWizardComponent
	{
		function getComponentData() : Object;
		function validateComponentData() : Boolean;
		function finalizeComponent() : void;
	}
	
}