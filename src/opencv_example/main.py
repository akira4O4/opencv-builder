import cv2

img = cv2.imread('../image.png')
cv2.imshow("image", img)
cv2.waitKey(0)