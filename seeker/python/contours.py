class Contour:
  def __init__(self, matrix, level, top, left, bottom, right):
    self.matrix = matrix
    self.level = level
    self.top = top
    self.left = left
    self.bottom = bottom
    self.right = right
    self.getLine()
    
  def getLine(self):
    self.line = []
    # top
    topLine = [(self.top, i) for i in range(self.left, self.right+1)]
    rightLine = [(j, self.right) for j in range(self.top+1, self.bottom)]
    bottomLine = [(self.bottom, i) for i in range(self.right, self.left-1, -1) if self.bottom > self.top]
    leftLine = [(j, self.left) for j in range(self.bottom-1, self.top, -1) if self.right > self.left]
    self.line.extend(topLine)
    self.line.extend(rightLine)
    self.line.extend(bottomLine)
    self.line.extend(leftLine)
    print(self.line)
    
  def clockwise(self):
    self.wise = []
    self.append(self.line[-1])
    self.wise.extend(self.line[0:-1])
    
  def counterwise(self):
    self.wise = []
    self.wise.extend(self.line[1:])
    self.wise.append(self.line[0])
    
  def shift(self):
    if self.level % 2  == 0:
      self.clockwise()
    else:
      self.counterwise()
    print(self.wise)
    
  def fill(self, target):
    for i in range(len(self.line)):
      target[self.line[i][0]][self.line[i][1]] = self.matrix[self.wise[i][0]][self.wise[i][1]]
    
def printMatrix(matrix):
  for item in matrix:
    print(item)
    

def solution(matrix):
  c1 = Contour(matrix, 1, 0, 0, 7, 0)
  c1.shift()
  result = []
  for row in matrix:
    result.append(row.copy())
  #result = matrix.copy()
  c1.fill(result)
  return result



matrix = []
for i in range(8):
  row = []
  for j in range(8):
    row.append(i*8+j+1)
  matrix.append(row)
printMatrix(matrix)
printMatrix(solution(matrix))

'''Mark got a rectangular array matrix for his birthday, and now he's thinking about all the fun things he can do with it. He likes shifting a lot, so he decides to shift all of its i-contours in a clockwise direction if i is even, and counterclockwise if i is odd.
Here is how Mark defines i-contours:
the 0-contour of a rectangular array as the union of left and right columns as well as top and bottom rows;
consider the initial matrix without the 0-contour: its 0-contour is the 1-contour of the initial matrix;
define 2-contour, 3-contour, etc. in the same manner by removing 0-contours from the obtained arrays.
Implement a function that does exactly what Mark wants to do to his matrix.
Example
For
matrix = [[ 1,  2,  3,  4],
           [ 5,  6,  7,  8],
           [ 9, 10, 11, 12],
           [13, 14, 15, 16],
           [17, 18, 19, 20]]
the output should be
contoursShifting(matrix) = [[ 5,  1,  2,  3],
                             [ 9,  7, 11,  4],
                             [13,  6, 15,  8],
                             [17, 10, 14, 12],
                             [18, 19, 20, 16]]
For matrix = [[238, 239, 240, 241, 242, 243, 244, 245]],
the output should be
contoursShifting(matrix) = [[245, 238, 239, 240, 241, 242, 243, 244]].
Note, that if a contour is represented by a 1 × n array, its center is considered to be below it.
For
matrix = [[238],
           [239],
           [240],
           [241],
           [242],
           [243],
           [244],
           [245]]
the output should be
contoursShifting(matrix) = [[245],
                             [238],
                             [239],
                             [240],
                             [241],
                             [242],
                             [243],
                             [244]]
If a contour is represented by an n × 1 array, its center is considered to be to the left of it.
Input/Output
[time limit] 4000ms (py)
[input] array.array.integer matrix
Constraints:
1 ≤ matrix.length ≤ 100,
1 ≤ matrix[i].length ≤ 100,
1 ≤ matrix[i][j] ≤ 1000.
[output] array.array.integer
The given matrix with its contours shifted.'''
