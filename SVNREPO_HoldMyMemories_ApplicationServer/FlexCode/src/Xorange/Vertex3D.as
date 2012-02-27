/* X.O.R.A.N.G.E --- Xtensible Object oRiented Actionscript Networked Graphics Engine
	This file is a part of Xorange Graphics engine.
	For conditions of distribution and use contact author at:- alok.rao@gmail.com
		Copyright (c) Alok Rao 2006.
*/

package Xorange{
    public class Vertex3D 
    {
        // 3D coordinates
        public var x:Number;
        public var y:Number;
        public var z:Number;
        // Vertex Normals
        public var nx:Number;
        public var ny:Number;
        public var nz:Number;
        // Texture Coordinates
        public var u:Number;
        public var v:Number;
        //Color
        public var color:int;
        public function Vertex3D(_x:Number = 0,_y:Number = 0,_z:Number = 0) 
        {
            x = _x;
            y = _y;
            z = _z;
            nx = 0;
            ny = 0;
            nz = 0;
            u = 0;
            v = 0;
            color = 0x00000000; // Color format is ARGB
        }
       
    }
}