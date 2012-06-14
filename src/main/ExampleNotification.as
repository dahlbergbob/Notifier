/**
 * User: Bob Dahlberg
 * Date: 2012-06-14
 * Time: 08:26
 */
package
{
	import com.boblu.notification.Notification;

	public class ExampleNotification extends Notification
	{
		public static const EXAMPLE:ExampleNotification = new ExampleNotification( "EXAMPLE" );
		
		public function ExampleNotification( type:String = "" )
		{
			super( type );
		}
	}
}
