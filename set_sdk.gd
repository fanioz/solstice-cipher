@tool
extends EditorScript

func _run():
	var settings = EditorInterface.get_editor_settings()
	settings.set("export/android/android_sdk_path", "/Users/fanioz/Library/Android/sdk")
	settings.set("export/android/java_sdk_path", "/Applications/Android Studio.app/Contents/jbr/Contents/Home")
	settings.save()
	print("Editor Settings Updated successfully via EditorScript")
	get_editor_interface().get_command_palette().execute_command("editor/quit")
