#!/usr/bin/env python3
import re
import sys


class Row:
    def __init__(self):
        self.left = ""
        self.middle_dir = ""
        self.middle = ""
        self.right = ""

    def __str__(self):
        idt = " " * 2
        blocks = []
        if self.left:
            blocks.append(idt + self.left)
            if self.middle_dir:
                blocks.append("\n")

        blocks.append(idt + r"\<")

        if self.middle_dir:
            blocks.append(r"\sendmessage" + self.middle_dir + "*")
            blocks.append("{" + self.middle + "}")
            if self.right:
                blocks.append("\n" + idt)

        blocks.append(r"\<")

        if self.right:
            blocks.append(self.right)

        blocks.append(r" \\")

        return "".join(blocks)


def usage():
    print("Usage: diagram.py inputfile outputfile", file=sys.stderr)
    sys.exit(1)


def main():
    if len(sys.argv) != 3:
        usage()

    state = "START LEFT"
    rows = [Row()]
    f = open(sys.argv[1], "r") if sys.argv[1] != "-" else sys.stdin
    out = open(sys.argv[2], "w") if sys.argv[2] != "-" else sys.stdout
    with f:
        title = f.readline().strip()
        left, _, right = [a.strip for a in f.readline().strip().partition("<->")]
        print("\\begin{figure}\n\\centering\n\\fbox{\n \\procedure{}{", file=out)
        print(r"  \textbf{" + left + r"}  \<\< \textbf{" + right + r"} \\", file=out)
        print(r"  [0.1\baselineskip][\hline] \\", file=out)
        for line in f:
            line, _, _ = line.strip().partition("#")
            if not line:
                continue

            if "LEFT" in state:
                if re.match(r"^->", line):
                    if rows[-1].middle_dir != "":
                        rows.append(Row())
                    rows[-1].middle_dir = "right"
                    rows[-1].middle = line[2:].strip()
                    state = "START RIGHT"
                else:
                    if "START" not in state:
                        rows.append(Row())
                    rows[-1].left = line
                    state = "LEFT"
            elif "RIGHT" in state:
                if re.match(r"^<-", line):
                    if rows[-1].middle_dir != "":
                        rows.append(Row())
                    rows[-1].middle_dir = "left"
                    rows[-1].middle = line[2:].strip()
                    state = "START LEFT"
                else:
                    if "START" not in state:
                        rows.append(Row())
                    rows[-1].right = line
                    state = "RIGHT"

        for row in rows:
            print(row, file=out)

        print(" }\n}", file=out)
        print("\\caption{The " + title + " Protocol}", file=out)
        print("\\label{fig:" + title + "}", file=out)
        print("\\end{figure}", file=out)


if __name__ == "__main__":
    sys.exit(main())
