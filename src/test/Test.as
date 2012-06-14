/**
 * User: Bob Dahlberg
 * Date: 2012-02-24
 * Time: 09:53
 */
package
{
	import com.boblu.lurunner.LUContainer;
	import com.boblu.lurunner.LURunner;
	import com.boblu.notification.NotificationSuite;
	import org.flexunit.listeners.CIListener;
	import org.flexunit.runner.FlexUnitCore;

	final public class Test extends LUContainer
	{
		protected var _core:FlexUnitCore;
		protected var _runner:LURunner;
		protected var _allSuites:Array;
		
		override protected function setup():void
		{
			TestUtil.stage = stage;
			
			_allSuites 	= [NotificationSuite];
			_runner 	= new LURunner();
			addChild( _runner );
		}

		override protected function start():void
		{
			_core = new FlexUnitCore();
			_core.addListener( _runner );
			_core.addListener( new CIListener() );
			_core.run( _allSuites );
		}
	}
}
