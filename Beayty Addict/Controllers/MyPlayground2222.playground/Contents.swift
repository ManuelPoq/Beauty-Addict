import UIKit

var str = "Hello, playground"


func factorial(n: Int) -> Int {
    return factorial(n: n-1) * n
}

let x = factorial(n: 3)
print(x)
