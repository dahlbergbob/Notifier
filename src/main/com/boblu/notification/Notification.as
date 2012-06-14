/*
 * Notifier 1.0
 * Copyright (C) 2012 Bob Dahlberg
 * 
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 * 
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 * 
 * You should have received a copy of the GNU General Public License
 * along with this program. If not, see <http://www.gnu.org/licenses/>.
 */
package com.boblu.notification 
{
	CONFIG::debug
	import flash.utils.getQualifiedClassName;
	
	/**
	 * The base Notification class for simplified use of notifications.
	 * It provides a print/trace/debug friendly toString function in debug mode.
	 * 
	 * @author Bob Dahlberg
	 */
	public class Notification implements INotification
	{
		protected var _type:String;
		
		/**
		 * Creates a new notification type with an optional type.
		 * @param value
		 */
		public function Notification( type:String = "" )
		{
			_type = type;
		}
		
		/**
		 * Returns the Notification class and Notification (if provided) type as a String
		 * @return		NotificationClass.NotificationType as String
		 */
		public function toString():String
		{
			CONFIG::debug
			{
				return getQualifiedClassName( this )+"."+ _type;
			}
			return _type;
		}
	}
}
