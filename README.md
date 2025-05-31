# Cosine Similarity in MIPS  

**Written by:** Yousef Mustafa  
**ID:** 20239502126  


## Objective

The primary aim of this assignment is to demonstrate how **MIPS assembly language** can be applied to solve real-world problems, specifically through the implementation of **cosine similarity**. This enhances the understanding of low-level performance optimization and algorithmic logic in systems where efficiency is critical.

MIPS is often used in environments such as embedded systems, where minimal instruction cycles and direct hardware interaction matter. Some real-world use cases of cosine similarity in such contexts include:

- Anomaly detection  
- Gesture recognition  
- Robotics  
- Real-time sensor data comparison  
- And many more...


## Theory

> **Note:** This program was developed and tested using the [MARS Simulator](https://dpetersanderson.github.io/), which supports MIPS assembly execution in an educational environment.

To model the behavior of cosine similarity in MIPS, the following mathematical concepts were implemented:

### Dot Product

The **dot product** of two vectors **A** and **B** is the sum of the products of their corresponding elements:

$$
\mathbf{A} \cdot \mathbf{B} = A_1B_1 + A_2B_2 + \dots + A_nB_n
$$


### Euclidean Norm

The **Euclidean norm** (or length) of a vector **A** is the square root of the sum of the squares of its elements:

$$
\|\mathbf{A}\| = \sqrt{A_1^2 + A_2^2 + \dots + A_n^2}
$$


### Cosine Similarity

The **cosine similarity** between two vectors **A** and **B** is defined as the dot product divided by the product of their magnitudes:

$$
\cos(\theta) = \frac{\mathbf{A} \cdot \mathbf{B}}{\|\mathbf{A}\| \cdot \|\mathbf{B}\|}
$$


## Design

The diagrams below illustrate the execution flow and logic of the program.

### "main" Function Flow

![[{5A951FD0-E810-4F41-9C76-E9DC49E740FC}.png]]


### "cosine_similarity" Function Flow

![[{BE5BCBDE-1524-42E1-A381-2258C037996D}.png]]


### "dot_product" Function Flow

![[{09C0CB80-7311-441F-8522-93325E6EDD93}.png]]


### "euclidean_norm" Function Form

![[{6AA58791-0B0D-4418-8BB3-38415C70CBA4}.png]]


## Implementation

The program is structured into the following modular procedures:
- `main`
- `cosine_similarity`
- `dot_product`
- `euclidean_norm`
- `bad_vector_size_exception`


### `main`

**Arguments**
`$s0`: size of vectors A and B
`$a0`: base address of vector A (`0x10010000`)
`$a1`: base address of vector B (`0x10010040`)

The main body of the program, receiving the user's vector size input, validating the input, and then calls `cosine_similarity` to compute the result, finally printing out the result.


### `cosine_similarity`

**Arguments**
`$a2`: first vector base address
`$a3`: second vector base address

**Returns**
`$f30`: float of cosine similarity between first and second vector

Responsible for returning the **cosine similarity**, given two vectors as arguments. This procedure is also responsible for calling `dot_product` (to calculate the numerator part of the formula), as well calling `euclidean_norm` for each vector (to calculate the denominator part of the formula).

> **Note:** The stack was used to store extra temporary variables across procedure calls, due to the program's specifications to only use registers `$f10` and `$f20` for temporary float calculations.


### `dot_product`

**Arguments**
`$a2`: first vector base address
`$a3`: second vector base address

**Returns**
`$f30`: float of dot product between first and second vector

A modular procedure that takes in any two vectors, and computes the **dot product** using the dot product algorithm, finally returning the result to the caller.


### `euclidean_norm`

**Arguments**
`$a2`: vector base address

**Returns**
`$f30`: float of vector's Euclidean norm

Takes in a vector, calculating the dot product of the vector with itself by calling the `dot_product` procedure, the finally square rooting the dot product and returning to the caller.


## Debugging and Test Run

Testing and debugging were used to catch and resolve bugs, some test cases include:

- Inputting invalid vector sizes (e.g., float/char inputs, inputs greater than 10 or less than 5)
- Inputting invalid vector elements (e.g., any type other than integer/float, empty elements)
- Prematurely exiting the program while running
- Entering very large or very small variables

Due to MIPS' robust type-safety, many test cases returned:

```console
Error in *PATH* line *LINE*: Runtime exception at *ADDRESS*: invalid float input (syscall *NUMBER*)

Go: execution terminated with errors.
```

The out-of-bounds vector size exception throws the following output:

```console
Welcome to MIPS Assembly using MARS Simulator
An assembly program to compute cosine similarity between two variables
Written by: Yousef Mustafa; 20239502126

Enter a vector size m between 5 and 10: 4

Vector must be between 5 and 10.

-- program is finished running --
```

These test cases were able to identify shortcomings in the program's logic, including switching the `syscall` that reads user inputs of vector elements to read floats instead of integers.

```mips
li      $v0, 6
# BEFORE: li $v0, 5 (only reads integers)
syscall
```

---

### Successful Test Run

Below is a console log of a successful test run, with varied inputs (floats, integers, negatives). The final answer was manually calculated to confirm the result.

```console
Welcome to MIPS Assembly using MARS Simulator
An assembly program to compute cosine similarity between two variables
Written by: Yousef Mustafa; 20239502126

Enter a vector size m between 5 and 10: 5
Input vector a elements:
4.5
5
4
2
1
Input vector b elements:
5.4
-1.2
-1
4
5
Cosine similarity result: 0.39364198

-- program is finished running --
```


## Conclusion and Future Improvements

While the program correctly calculates the cosine similarity between two vectors and is robust under various test conditions, expanding the functionality to compute the similarity among **multiple vectors** can provide deeper insights. One useful approach is to compute the **average pairwise cosine similarity** using the formula:

$$
\text{average\ similarity} = \frac{2}{n(n - 1)} \sum_{i < j} \text{cosine\ similarity}(v_i, v_j)
$$

Where:

- $n$ is the total number of vectors.
- $v_i,\ v_j$ are the $i$th and $j$th vectors in the set.
- $cosine\ similarity(v_i,\ v_j)$ is the cosine similarity between vectors $v_i$ and $v_j$.
- The summation $\sum_{i < j}$ goes over all unique pairs of vectors where $i < j$, avoiding repetition. 

This enhancement would allow the program to assess the **overall similarity** or **cohesion** of a group of vectors, which is especially useful in applications like clustering, topic modeling, and document similarity analysis.


## Contributions

AI assistance was used as a learning tool rather than for direct answers. Instead of copying solutions, I attempted problems independently and sought help only for specific issues to deepen my understanding.

For example, when the program specification lacked enough temporary variables to compute cosine similarity, the AI suggested using `.data` declarations or the stack. This led to the idea of leveraging the stack for storing intermediate values. Additionally, the AI helped clarify how to call procedures within procedures while correctly managing return addresses using the stack.


## Appendix A

The full code can be found in the GitHub repository, the program is named `program.s`.


## Appendix B

A sample conversation with the AI assistant can be found in the GitHub repository, the conversation is named `conversation.txt`.
