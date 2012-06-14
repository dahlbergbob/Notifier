/**
 * User: Bob Dahlberg
 * Date: 2012-06-12
 * Time: 11:01
 */
package com.boblu.notification.mock
{
	import com.boblu.notification.Notification;

	public class MockNotification extends Notification
	{
		public static const MOCK_ONE:MockNotification 	= new MockNotification( "ONE" );
		public static const MOCK_TWO:MockNotification 	= new MockNotification( "TWO" );
		public static const MOCK_THREE:MockNotification = new MockNotification( "THREE" );
		public static const MOCK_FOUR:MockNotification 	= new MockNotification( "FOUR" );

		/**
		 * Creates a new notification type with an optional type.
		 * @param type
		 */
		public function MockNotification( type:String = "" )
		{
			super( type );
		}
	}
}
