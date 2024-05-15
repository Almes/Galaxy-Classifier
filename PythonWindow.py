import PySimpleGUI as sg
import subprocess
import os

from PIL import ImageTk
from PIL import Image


def main():
    # size of the window itself and buttons
    layout = [
        [sg.Canvas(size=(500, 500), background_color='white', key='-CANVAS-')],
        [sg.Button('Open Image'), sg.Button('Process Image')]
    ]

    #name of the window
    window = sg.Window('Drag and Drop Image', layout, finalize=True)
    canvas = window['-CANVAS-'].TKCanvas
    imgPth = None

    #what happens when you input the image, either passes to matlab if appropriate image, otherwise error
    while True:
        event, values = window.read()
        if event == sg.WINDOW_CLOSED:
            break
        elif event == 'Open Image':
            imgPth = sg.popup_get_file('Open Image', file_types=(("Image files", "*.png;*.jpg;*.jpeg;*.gif"),))
            if imgPth:
                draw_image(canvas, imgPth)
        elif event == 'Process Image':
            if imgPth:
                pass_to_matlab(imgPth)
            else:
                sg.popup_error('No image selected!')

    window.close()

#changes the window of the program to the picture once uploaded
def draw_image(canvas, imgPth):
    canvas.delete('all')
    img = Image.open(imgPth)
    img = ImageTk.PhotoImage(img)
    canvas.create_image(0, 0, anchor='nw', image=img)
    canvas.img = img


def pass_to_matlab(imgPth):
    # Save the image to a temporary location
    tempImgPth = os.path.join(os.getcwd(), "tempImg.jpg")
    with open(imgPth, 'rb') as f:
        with open(tempImgPth, 'wb') as temp_f:
            temp_f.write(f.read())

    # Call MATLAB script with the image path as argument
    # Had to put the r in front of the string because python seems to have scruples about using normal strings
    matlabScript = r"firstImg.m"
    #specifically :matlab opens matlab
    #desktop: makes it to where matlab doesn't open itself and instead opens a temp window
    #firstImg, the function I'm calling from my matlab script
    #exit and wait: waits for the script to finish then exits the program
    subprocess.call(["matlab", "-nodesktop", "-r", "firstImg('{}');".format(imgPth, matlabScript,), "-wait"])

    #removing the temp img from matlab
    os.remove(tempImgPth)


if __name__ == "__main__":
    main()
