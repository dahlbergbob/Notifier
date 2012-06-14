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
	import flash.utils.Dictionary;

	/**
	 * The Notifier that works in the manner of an event dispatcher but handles notifications and strongly typed notes instead of loose event-types used natively.
	 * It is a middle thing between native events and as3 signals which combines the pro's with signals in a more ActionScript-native way.
	 * 
	 * @author Bob Dahlberg
	 */
	public class Notifier implements INotifier
	{
		private var _handledNotifications:Vector.<INotification>;
		private var _notificationListenerMap:Dictionary;
		private var _timesMap:Dictionary;
		
		public function Notifier() 
		{
			_handledNotifications 		= new Vector.<INotification>();
			_notificationListenerMap	= new Dictionary( true );
			_timesMap					= new Dictionary( true );
		}

		/**
		 * Add a listener for a specific notification if the listener isn't allready mapped to the listener.
		 * @param notification	The notification to listen to
		 * @param listener		The listener to be mapped with the notification
		 * @param times			The number of times this listener will be triggered by this specific notification (default 0 that means unlimited times).
		 * @return				True if the listener is added, false if it's not. Note that if the listener is not added the number of times it should be called is not updated.
		 */
		public function addNotificationListener( notification:INotification, listener:Function, times:int = 0 ):Boolean
		{
			var listenersForNotification:Vector.<Function> = handleNotification( notification ); 
			
			if( listenersForNotification.indexOf( listener ) == -1 )
			{
				listenersForNotification.push( listener );
				if( times > 0 )
					_timesMap[listener] = times;
				
				return true;
			}
			return false;
		}

		/**
		 * Saves the notification with a mapped listener vector attached to it.
		 * @param notification	The notification to which we want to listen
		 * @return		The mapped listener vector for the notification.
		 */
		private function handleNotification( notification:INotification ):Vector.<Function>
		{
			if( _handledNotifications.indexOf( notification ) == -1 )
			{
				_handledNotifications.push( notification );
				_notificationListenerMap[notification] = new Vector.<Function>();
			}
			
			return _notificationListenerMap[notification];
		}

		/**
		 * Notify all listeners for a specific notification with an optional settings of parameters
		 * @param notification		The INotification for which to send out the notification
		 * @param params			0 to N number parameters to send to the listeners (optional)
		 */
		public function notify( notification:INotification, ... params ):void
		{
			var listeners:Vector.<Function> = _notificationListenerMap[notification];
			
			if( listeners != null )
			{
				// Make a copy
				var loopingListeners:Vector.<Function> = listeners.slice();
				
				for each( var listener:Function in loopingListeners )
				{
					if( params && params.length )
						listener.apply( this, params );
					else
						listener();

					if( !isStillActive( listener ) )
						removeListener( notification, listener );
				}
			}
		}

		/**
		 * Removes a specific listener from a Notification.
		 * @param notification		The notification from which to remove the listener.
		 * @param listener	The listener to remove
		 */
		private function removeListener( notification:INotification, listener:Function ):void
		{
			var listeners:Vector.<Function> = _notificationListenerMap[notification];
			var index:int = listeners.indexOf( listener );
			
			if( index > -1 )
				listeners.splice( index, 1 );
			
			if( listeners.length == 0 )
				removeNotification( notification );
		}

		/**
		 * Removes a notification from this notifiers register.
		 * @param notification
		 */
		private function removeNotification( notification:INotification ):void
		{
			_notificationListenerMap[notification] = null;
			_handledNotifications.splice( _handledNotifications.indexOf( notification ), 1 );
		}

		/**
		 * Checks to see if a listener still is active or if it should be removed automatically 
		 * @param listener	The listener to check
		 * @return			true if the listener has times left, false if it should be removed.
		 */
		private function isStillActive( listener:Function ):Boolean
		{
			if( _timesMap[listener] != null )
			{
				_timesMap[listener]--;
				var timesLeft:int = _timesMap[listener];
				
				if( isNaN( timesLeft ) || timesLeft <= 0 )
				{
					_timesMap[listener] = null;
					delete _timesMap[listener];
					return false;
				}
			}
			return true;
		}

		/**
		 * Remove a specific listener for a notification
		 * @param notification		The notification that the listener is attached to
		 * @param listener	The listener to remove
		 */
		public function removeNotificationListener( notification:INotification, listener:Function ):void
		{
			removeListener( notification, listener );
			_timesMap[listener] = null;
			delete _timesMap[listener]; 
		}

		/**
		 * Removes all listener for one notification
		 * @param notification	The notification that no longer will have any listeners
		 */
		public function clearNotificationListeners( notification:INotification ):void
		{
			var index:int = _handledNotifications.indexOf( notification ); 
			if( index > -1 )
			{
				var listeners:Vector.<Function> = _notificationListenerMap[notification];
				for each( var listener:Function in listeners )
				{
					_timesMap[listener] = null;
					delete _timesMap[listener];
				}
				
				_notificationListenerMap[notification] = null;
				delete _notificationListenerMap[notification];
				
				_handledNotifications.splice( index, 1 );
			}
		}

		/**
		 * Add any number of listeners for one notification
		 * @param notification		The notification to listen on
		 * @param listeners	0 to N number of listeners for the notification
		 */
		public function addNotificationListeners( notification:INotification, ... listeners ):void
		{
			for each( var listener:Function in listeners )
				addNotificationListener( notification, listener );
		}
		
		/**
		 * Remove any number of listeners for one notification
		 * @param notification		The notification that the listener is attached to
		 * @param listeners	0 to N number of listeners for the notification to remove
		 */
		public function removeNotificationListeners( notification:INotification, ... listeners ):void
		{
			for each( var listener:Function in listeners )
				removeListener( notification, listener );
		}
		
		/**
		 * Add any number of notifications to listen to with one listener
		 * @param listener	The listener for the notification
		 * @param notifications		0 to N number of notifications to listen on
		 */
		public function addListenerForNotifications( listener:Function, ... notifications ):void
		{
			for each( var notification:INotification in notifications )
				addNotificationListener( notification, listener );
		}

		/**
		 * Removes any number of notifications listened on by one listener
		 * @param listener	The listener for the notifications
		 * @param notifications		0 to N number of notifications to remove notifications for
		 */
		public function removeListenerForNotifications( listener:Function, ... notifications ):void
		{
			for each( var notification:INotification in notifications )
				removeListener( notification, listener );
		}


		/**
		 * Clear the entire dispatcher from notifications and listeners
		 */
		public function clearNotifier():void
		{
			_handledNotifications 		= new Vector.<INotification>();
			_notificationListenerMap 	= new Dictionary( true );
			_timesMap			= new Dictionary( true );
		}
	}
}
