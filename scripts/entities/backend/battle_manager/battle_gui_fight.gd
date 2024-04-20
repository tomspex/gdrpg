extends RichTextLabel;

signal gui_option_finished;

func execute():
	print("fight option executed!");
	gui_option_finished.emit();
