/**
 * User: Bob Dahlberg
 * Date: 2012-02-27
 * Time: 08:37
 */
package com.boblu.notification
{
	import com.boblu.notification.mock.MockNotification;
	import org.hamcrest.assertThat;
	import org.hamcrest.core.not;
	import org.hamcrest.object.equalTo;

	public class NotificationTest
	{
		private var _notifier:Notifier;
		private var _result:*;
		
		[Before]
		public function setUp():void
		{
			_notifier = new Notifier();
			_result = null;
		}

		[After]
		public function tearDown():void
		{
			_notifier = null;
			_result = null;
		}

		[Test(description="Test adding a notification-listener and see that it is called.")]
		public function testNotification():void
		{
			var respons:String;

			_notifier.addNotificationListener( MockNotification.MOCK_ONE, function():void{
				respons = "HI";
			} );

			_notifier.notify( MockNotification.MOCK_ONE );
			assertThat( respons, equalTo( "HI" ) );
		}

		[Test(description="Test adding one notification-listener multiple times to see that it's only called once.")]
		public function testMultipleNotificationAdds():void
		{
			_result = 0;
			_notifier.addNotificationListener( MockNotification.MOCK_ONE, onMultipleCall );
			_notifier.addNotificationListener( MockNotification.MOCK_ONE, onMultipleCall );
			_notifier.addNotificationListener( MockNotification.MOCK_ONE, onMultipleCall );
			_notifier.notify( MockNotification.MOCK_ONE );
			assertThat( _result, equalTo( 1 ) );
		}
		private function onMultipleCall():void	{	_result++;	}


		[Test(description="Test adding notification-listener N number of times to see that it's only called N times.")]
		public function testNotifiedSpecificAmountOfTimes():void
		{
			var timesToBeCalled:int = 2;
			_result = 0;
			_notifier.addNotificationListener( MockNotification.MOCK_ONE, onTimesCalled, timesToBeCalled );
			_notifier.notify( MockNotification.MOCK_ONE );
			_notifier.notify( MockNotification.MOCK_ONE );
			_notifier.notify( MockNotification.MOCK_ONE );
			_notifier.notify( MockNotification.MOCK_ONE );

			assertThat( _result, equalTo( timesToBeCalled ) );
		}
		private function onTimesCalled():void	{	_result++;	}


		[Test(description="Test notifying one notification several times.")]
		public function testNotifiedSeveralTimes():void
		{
			var timesToBeCalled:int = 4;
			_result = 0;
			_notifier.addNotificationListener( MockNotification.MOCK_ONE, onTimesCalled );
			_notifier.notify( MockNotification.MOCK_ONE );
			_notifier.notify( MockNotification.MOCK_ONE );
			_notifier.notify( MockNotification.MOCK_ONE );
			_notifier.notify( MockNotification.MOCK_ONE );

			assertThat( _result, equalTo( timesToBeCalled ) );
		}


		[Test(description="Test sending parameters to a listener.")]
		public function testSendingParameters():void
		{
			var data:Object = { fake:"javesst", mock:true, on_the_fly:null };
			_result = null;
			_notifier.addNotificationListener( MockNotification.MOCK_TWO, onParameterCall )
			_notifier.notify( MockNotification.MOCK_THREE, ["arr","arr","arr"] );
			_notifier.notify( MockNotification.MOCK_TWO, data );
			assertThat( _result, equalTo( data ) );
		}
		private function onParameterCall( sendThrough:Object ):void	{	_result = sendThrough;	}
		
		
		[Test(description="Test sending parameters to a listener that don't accept them.")]
		public function testSendingParametersException():void
		{
			var exceptionThrown:Boolean = false;
			_notifier.addNotificationListener( MockNotification.MOCK_FOUR, onParameterExceptionCall );
			
			try { _notifier.notify( MockNotification.MOCK_FOUR, "one", "failing", "array" ); }
			catch( e:ArgumentError ){ exceptionThrown = true; }
			
			assertThat( exceptionThrown, equalTo( true ) );
		}
		private function onParameterExceptionCall():void{}


		[Test(description="Test removing listener.")]
		public function testRemoveListener():void
		{
			_result = null;
			_notifier.addNotificationListener( MockNotification.MOCK_ONE, onRemoved1Called );
			_notifier.addNotificationListener( MockNotification.MOCK_ONE, onRemoved2Called );
			_notifier.removeNotificationListener( MockNotification.MOCK_ONE, onRemoved1Called );
			_notifier.notify( MockNotification.MOCK_ONE );
			assertThat( _result, equalTo( 2 ) );
		}
		private function onRemoved1Called():void	{	_result = 1;	}
		private function onRemoved2Called():void	{	_result = 2;	}

		[Test(description="Test removing listener that don't excist.")]
		public function testRemoveListenerThatDontExcist():void
		{
			_result = null;
			_notifier.addNotificationListener( MockNotification.MOCK_ONE, onRemoved2Called );
			_notifier.removeNotificationListener( MockNotification.MOCK_ONE, onRemoved1Called );
			_notifier.notify( MockNotification.MOCK_ONE );
			assertThat( _result, equalTo( 2 ) );
		}

		[Test(description="Test removing all for notification.")]
		public function testRemoveListenersForNote():void
		{
			_result = null;
			_notifier.addNotificationListener( MockNotification.MOCK_ONE, onRemoved2Called );
			_notifier.notify( MockNotification.MOCK_ONE );
			assertThat( _result, equalTo( 2 ) );

			_result = null;
			_notifier.addNotificationListener( MockNotification.MOCK_ONE, onRemoved1Called );
			_notifier.notify( MockNotification.MOCK_ONE );
			assertThat( _result, equalTo( 1 ) );

			_result = null;
			_notifier.clearNotificationListeners( MockNotification.MOCK_ONE );
			_notifier.notify( MockNotification.MOCK_ONE );
			assertThat( _result, equalTo( null ) );
		}

		[Test(description="Adding several listeners for one notification.")]
		public function testAddSeveralListenersForOneNote():void
		{
			_result = 0;

			_notifier.addNotificationListeners( MockNotification.MOCK_THREE, onNote1, onNote2, onNote3 );
			_notifier.notify( MockNotification.MOCK_THREE );
			assertThat( _result, equalTo( 3 ) );

			_result = 0;
			_notifier.addNotificationListeners( MockNotification.MOCK_TWO, onNote1 );
			_notifier.notify( MockNotification.MOCK_TWO );
			assertThat( _result, equalTo( 1 ) );

			_result = 0;
			_notifier.clearNotificationListeners( MockNotification.MOCK_THREE );
			_notifier.addNotificationListeners( MockNotification.MOCK_THREE );
			_notifier.notify( MockNotification.MOCK_THREE );
			assertThat( _result, equalTo( 0 ) );
		}
		private function onNote1():void	{	_result++;	}
		private function onNote2():void	{	_result++;	}
		private function onNote3():void	{	_result++;	}
		
		[Test(description="Removing several listeners for one notification.")]
		public function testRemoveSeveralListenersForOneNote():void
		{
			_result = 0;

			_notifier.addNotificationListeners( MockNotification.MOCK_THREE, onNote1, onNote2, onNote3 );
			_notifier.notify( MockNotification.MOCK_THREE );
			assertThat( _result, equalTo( 3 ) );

			_result = 0;
			_notifier.removeNotificationListeners( MockNotification.MOCK_THREE, onNote1, onNote2 );
			_notifier.notify( MockNotification.MOCK_THREE );
			assertThat( _result, equalTo( 1 ) );
		}
		
		[Test(description="Clearing the notifier.")]
		public function testClearingNotifier():void
		{
			_result = 0;

			_notifier.addNotificationListeners( MockNotification.MOCK_ONE, alterResult, onNote2, onNote3, onNote1, onRemoved1Called, onRemoved2Called, onMultipleCall );
			_notifier.addNotificationListeners( MockNotification.MOCK_TWO, alterResult, onNote2, onNote3, onNote1, onRemoved1Called, onRemoved2Called, onMultipleCall );
			_notifier.addNotificationListeners( MockNotification.MOCK_THREE, alterResult, onNote2, onNote3, onNote1, onRemoved1Called, onRemoved2Called, onMultipleCall );
			_notifier.addNotificationListeners( MockNotification.MOCK_FOUR, alterResult, onNote2, onNote3, onNote1, onRemoved1Called, onRemoved2Called, onMultipleCall );
			
			_notifier.notify( MockNotification.MOCK_ONE );
			_notifier.notify( MockNotification.MOCK_TWO );
			_notifier.notify( MockNotification.MOCK_THREE );
			_notifier.notify( MockNotification.MOCK_FOUR );
			assertThat( _result, not( 0 ) );
			
			_result = 0;
			_notifier.clearNotifier();
			_notifier.notify( MockNotification.MOCK_ONE );
			_notifier.notify( MockNotification.MOCK_TWO );
			_notifier.notify( MockNotification.MOCK_THREE );
			_notifier.notify( MockNotification.MOCK_FOUR );
			assertThat( _result, equalTo( 0 ) );
		}
		private function alterResult():void	{	_result = Math.random();	}

		[Test(description="Different notifiers are handled separately.")]
		public function testUsingSeveralNotifiers():void
		{
			var notifier2:Notifier = new Notifier();
			_result = 0;

			_notifier.addNotificationListeners( MockNotification.MOCK_ONE, onNoteOne );
			notifier2.addNotificationListeners( MockNotification.MOCK_ONE, onNoteTwo );
			notifier2.notify( MockNotification.MOCK_ONE );
			assertThat( _result, equalTo( 20 ) );

			_notifier.clearNotifier();
			notifier2.clearNotifier();
			notifier2.addNotificationListeners( MockNotification.MOCK_ONE, onNoteTwo );
			_notifier.addNotificationListeners( MockNotification.MOCK_ONE, onNoteOne );
			notifier2.notify( MockNotification.MOCK_ONE );
			assertThat( _result, equalTo( 20 ) );

			_notifier.notify( MockNotification.MOCK_ONE );
			assertThat( _result, equalTo( 10 ) );

			notifier2.notify( MockNotification.MOCK_ONE );
			assertThat( _result, equalTo( 20 ) );
		}
		private function onNoteOne():void	{	_result = 10;	}
		private function onNoteTwo():void	{	_result = 20;	}

		[Test(description="Listening for several notes with one listener.")]
		public function testUsingOneListenerForSeveralNotes():void
		{
			_result = 0;

			_notifier.addListenerForNotifications( addOneToResult, MockNotification.MOCK_ONE, MockNotification.MOCK_FOUR, MockNotification.MOCK_THREE );
			_notifier.notify( MockNotification.MOCK_TWO );
			assertThat( _result, equalTo( 0 ) );
			_notifier.notify( MockNotification.MOCK_THREE );
			assertThat( _result, equalTo( 1 ) );
			_notifier.notify( MockNotification.MOCK_FOUR );
			assertThat( _result, equalTo( 2 ) );
			_notifier.notify( MockNotification.MOCK_ONE );
			_notifier.notify( MockNotification.MOCK_ONE );
			assertThat( _result, equalTo( 4 ) );
		}
		private function addOneToResult():void	{	_result++; }


		[Test(description="Remove listener for several notes with one listener.")]
		public function testRemovingOneListenerForSeveralNotes():void
		{
			_result = 0;

			_notifier.addListenerForNotifications( addOneToResult, MockNotification.MOCK_ONE, MockNotification.MOCK_FOUR, MockNotification.MOCK_THREE );
			_notifier.removeListenerForNotifications( addOneToResult, MockNotification.MOCK_ONE, MockNotification.MOCK_THREE );
			
			_notifier.notify( MockNotification.MOCK_TWO );
			assertThat( _result, equalTo( 0 ) );
			_notifier.notify( MockNotification.MOCK_THREE );
			assertThat( _result, equalTo( 0 ) );
			_notifier.notify( MockNotification.MOCK_FOUR );
			assertThat( _result, equalTo( 1 ) );
			_notifier.notify( MockNotification.MOCK_ONE );
			_notifier.notify( MockNotification.MOCK_ONE );
			assertThat( _result, equalTo( 1 ) );
		}
	}
}
