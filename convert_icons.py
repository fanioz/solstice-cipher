from PIL import Image
import os

img = Image.open('src/assets/sprites/prism.webp')
img = img.convert('RGBA')

img_192 = img.resize((192, 192))
img_192.save('android/icons/icon_192.png')

img_432 = img.resize((432, 432))
img_432.save('android/icons/foreground_432.png')

bg = Image.new('RGB', (432, 432), color='black')
bg.save('android/icons/background_432.png')
print("Icons generated.")
