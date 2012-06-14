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
	/**
	 * A full interface for dealing with Notifiers (notification dispatchers).
	 * @author Bob Dahlberg
	 */
	public interface INotifier 
	{
		/**
		 * Add a listener for a specific notification if the listener isn't allready mapped to the listener.
		 * @param notification	The notification to listen to
		 * @param listener		The listener to be mapped with the notification
		 * @param times			The number of times this listener will be triggered by this specific notification (default 0 that means unlimited times).
		 * @return				True if the listener is added, false if it's not. Note that if the listener is not added the number of times it should be called is not updated.
		 */
		function addNotificationListener( notification:INotification, listener:Function, times:int = 0 ):Boolean;

		/**
		 * Notify all listeners for a specific notification with an optional settings of parameters
		 * @param notification		The INotification for which to send out the notification
		 * @param params			0 to N number parameters to send to the listeners (optional)
		 */
		function notify( notification:INotification, ... params ):void;

		/**
		 * Remove a specific listener for a notification
		 * @param notification		The notification that the listener is attached to
		 * @param listener	The listener to remove
		 */
		function removeNotificationListener( notification:INotification, listener:Function ):void;

		/**
		 * Removes all listener for one notification
		 * @param notification	The notification that no longer will have any listeners
		 */
		function clearNotificationListeners( notification:INotification ):void;

		/**
		 * Add any number of listeners for one notification
		 * @param notification		The notification to listen on
		 * @param listeners	0 to N number of listeners for the notification
		 */
		function addNotificationListeners( notification:INotification, ... listeners ):void;

		/**
		 * Remove any number of listeners for one notification
		 * @param notification		The notification that the listener is attached to
		 * @param listeners	0 to N number of listeners for the notification to remove
		 */
		function removeNotificationListeners( notification:INotification, ... listeners ):void;

		/**
		 * Add any number of notifications to listen to with one listener
		 * @param listener	The listener for the notification
		 * @param notifications		0 to N number of notifications to listen on
		 */
		function addListenerForNotifications( listener:Function, ... notifications ):void;

		/**
		 * Removes any number of notifications listened on by one listener
		 * @param listener	The listener for the notifications
		 * @param notifications		0 to N number of notifications to remove notifications for
		 */
		function removeListenerForNotifications( listener:Function, ... notifications ):void;

		/**
		 * Clear the entire dispatcher from notifications and listeners
		 */
		function clearNotifier():void;
		
		
		/*
		SuperNotifier? - Adding/removing a whole INote class to listen for
		*/
	}
}
