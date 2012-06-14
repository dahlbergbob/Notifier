/**
 * User: Bob Dahlberg
 * Date: 2012-06-13
 * Time: 14:01
 */
package
{
	import flash.display.Sprite;
	import flash.events.Event;

	public class Main extends Sprite
	{
		/**
		 * Constructor makes sure the application has stage before proceeding
		 */
		public function Main()
		{
			if( stage == null )
				addEventListener( Event.ADDED_TO_STAGE, init );
			else
				init();
		}

		/**
		 * Starting the application 
		 */
		private function init( e:Event = null ):void
		{
			trace( ".: Running notifier example :." );
			exampleNotifier();
			compactNotifier();
			parametersNotifier();
		}
		
		private function exampleNotifier():void
		{
			/* The no brainer use of notifier, exactly like events (without sending the event itself over). */
			var notifier:ExampleNotifier = new ExampleNotifier();
			notifier.addNotificationListener( ExampleNotification.EXAMPLE, onExample );
			notifier.notify( ExampleNotification.EXAMPLE );
			notifier.clearNotifier();
		}
		private function onExample():void	{	trace( "onExample" );	}


		private function compactNotifier():void
		{
			/* 	Using the Notifier as it's best practice case where I use the Notifier class to embed the Notifications (more like the behavior of signals)
				So there is never any problems figuring out which notifications each one class is sending out. */
			var notifier:CompactNotifier = new CompactNotifier();
			notifier.addNotificationListener( CompactNotifier.COMPACT, onCompact );
			notifier.notify( CompactNotifier.COMPACT );
			notifier.clearNotifier();
		}
		private function onCompact():void	{	trace( "onCompact" );	}


		private function parametersNotifier():void
		{
			/* 	The same functionality as the CompactNotifier but sending parameters with the notification */
			var notifier:ParametersNotifier = new ParametersNotifier();
			notifier.addNotificationListener( ParametersNotifier.PARAMS, onParams );
			notifier.notify( ParametersNotifier.PARAMS, "\'value sent through\'" );
			notifier.clearNotifier();
		}
		private function onParams( value:String ):void	{	trace( "onParams: "+ value );	}

	}
}
