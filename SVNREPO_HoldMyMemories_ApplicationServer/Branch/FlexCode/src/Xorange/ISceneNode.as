/* X.O.R.A.N.G.E --- Xtensible Object oRiented Actionscript Networked Graphics Engine
	This file is a part of Xorange Graphics engine.
	For conditions of distribution and use contact author at:- alok.rao@gmail.com
		Copyright (c) Alok Rao 2006.
*/
package Xorange
{
	package scene {
					import core.*;
					// Still evaluating the use of abstract class against interface
					public interface ISceneNode
					{
						//! Called before rendering the node
						function onPreRender():void{}
						
						//! Called inorder to render a node.
						function render():void{}
						
						//! Called after rendering a node.
						function onPostRender():void{}
						
						//! Returns the debug name of the node. Will help when developing a scene editor for the \
						//! engine
						function getName():String{}
						
						//! Sets the debug name of the node.  Will help when developing a scene editor for the 
						//! engine
						function setName(name:String):void{}
						
						//! Returns the axis aligned bounding box of the node. All derived node types have to 
						//! implement this method. 
						function getBoundingBox():core.AaBb{}
						
						//! Returns the transformed bounding box.
						function getTransformedBoundingBox():core.AaBb{}
						
						//! Returns the absolute transformation matrix of the node
						function getAbsoluteTransformation():core.matrix4{}
						
						//! Returns the relative transformation Matrix
						function getRelativeTransformation():core.matrix4{}
						
						//! Returns wether the node is visible or not. Will be used in automatic object culling
						function isVisible():Boolean{}
						
						//! Sets wether the node is visible or not. Will be used in automatic culling
						function setVisible(visible:Boolean):void{}
						
						//! Returns the id of the node. ID will be used to identify the node for events
						function getID():int{}
						
						//! Sets the id of the node
						function setID(id:int):void{}
						
						//! Adds a child to the scene node
						function addChild(child:ISceneNode):void{}
						
						//! Removes a child of the scene node
						function removeChild(child:ISceneNode):Boolean{}
						
						//! Remove all children
						function removeAll():Boolean{}
						
						//! Remove this node from its parent node and delete it.
						function remove():void{}
						
						//! Sets the parent node of the scene node
						function setParent(parent:ISceneNode):void{}
						
						//! Returns the parent of the node
						function getParent():ISceneNode{}
						
						//! Get the list of children of the node
						function getChildren():Array{}
										
					}
	}
}