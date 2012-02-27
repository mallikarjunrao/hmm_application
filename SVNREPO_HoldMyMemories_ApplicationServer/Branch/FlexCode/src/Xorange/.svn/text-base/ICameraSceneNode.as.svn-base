/* X.O.R.A.N.G.E --- Xtensible Object oRiented Actionscript Networked Graphics Engine
	This file is a part of Xorange Graphics engine.
	For conditions of distribution and use contact author at:- alok.rao@gmail.com
		Copyright (c) Alok Rao 2006.
*/
package Xorange
{
	package scene
	{
		import flash.events.Event;
		import ISceneNode;
		import core.*;
	
				public interface ICameraSceneNode extends ISceneNode
				{
					//! Sets the projection matrix of the camera. 
					/** The core::matrix4 class has some methods
					to build a projection matrix. e.g: core.matrix4.buildProjectionMatrixPerspectiveFovLH.
					Note that the matrix will only stay as set by this method until one of 
					the following Methods are called: setNearValue, setFarValue, setAspectRatio, setFOV.
					\param projection: The new projection matrix of the camera.  */
					function setProjectionMatrix(projection:core.matrix4):void{}
					
					//! Returns the current projection matrix of the camera.
					/** \return Returns the current projection matrix of the camera. */
					function getProjectionMatrix():core.matrix4{}
					
					//! Gets the current view matrix of the camera.
					/** \return Returns the current view matrix of the camera. */
					function getViewMatrix():core.matrix4{};
					
					//! It is possible to send mouse and key events to the camera.
					function OnEvent(event:CEvent):Boolean{}
					
					//! Sets the look at target of the camera
					/** \param pos: Look at target of the camera. */
					function setTarget(pos:vector3d):void{}
					
					//! Gets the current look at target of the camera
					/** \return Returns the current look at target of the camera */
					function getTarget():core.vector3d{}
					
					//! Sets the up vector of the camera.
					/** \param pos: New upvector of the camera. */
					function setUpVector( pos:core.vector3d):void{}
					
					//! Gets the up vector of the camera.
					/** \return Returns the up vector of the camera. */
					function getUpVector():core.vector3d{} 
					
					//! \return Returns the value of the near plane of the camera.
					/** \return Returns the near plane of the camera */
					function getNearPlane():Number{}
					
					//! \return Returns the value of the far plane of the camera.
					function getFarPlane():Number{}

					//! \return Returns the aspect ratio of the camera.
					function getAspectRatio():Number{}

					//! \return Returns the field of view of the camera in radiants.
					function getFOV():Number{}

					//! Sets the value of the near clipping plane. (default: 1.0f)
					/** \param zn: New z near value. */
					function setNearPlane(_zn:Number):void{}

					//! Sets the value of the far clipping plane (default: 2000.0f)
					/** \param zf: New z far value. */
					function setFarValue(_zn:Number):void{}

					//! Sets the aspect ratio (default: 4.0f / 3.0f)
					/** \param aspect: New aspect ratio. */
					function setAspectRatio(aspect:Number):void{}

					//! Sets the field of view (Default: PI / 2.5f)
					/** \param fovy: New field of view in radiants. */
					function setFOV(fovy:Number):void{}

					//! Disables or enables the camera to get key or mouse inputs.
					/** If this is set to true, the camera will respond to key inputs
					 otherwise not. */
					function setInputReceiverEnabled(enabled:Boolean):void{}
			
					//! Returns if the input receiver of the camera is currently enabled.
					function isInputReceiverEnabled():Boolean{}
					
					//! Callback function for any event to be received by the camera
					function onEvent(event:Event):Boolean{}
				}
	}
}