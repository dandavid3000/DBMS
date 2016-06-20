>Library management system.

## Tables of contents
1. [Requirements](#requirements)
2. [Source code](#source-code)


### Requirements
#### Description
A library needs to manage users who can register, borrow, and return books.
* A librarian call content of a book is `tuasach` (Book Title). Example, the context could be `Toan Cao Cap A1` (Math A1), `Harry Porter chapter 8` ... Every book title is translated into different languages, and every translation is called `dausach` (Header of books). Every header has many coppies, and every coppy is called a `cuonsach` (book).
* Every book title has its own ID `matuasach`, It's automatically increased, and starts from 1,2,3... Every book title of an author `tacgia` has a summary `tomtat` of the book (It could be a sentence or several pages). When readers want to know content of the book, the librarian will take a look at the summary and answer to the readers.
* Every header of book has a status `trangthai` which shows its availability.
* To become a Reader or User `docgia` of the library, he/she needs to register with his information including the address, mobile phone number. The librarian supplies an electronic card. There is an ID card for each to distinct with others. (ID will be increased automatically from 1,2,3, ...). The ID card is valid in one year from the registration day. The librarian will notice to Readers if the card is going to be invalid 1 month before. 
* A reader `nguoilon` who is an adult (>18) can assure for children `treem` to become readers of the library. `nguoilon` and `treem` will have the same valid day. The librarian needs to know information of children including name, dob. When children is older than 18, the system will auto update the information to become an adult reader.

