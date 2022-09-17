//
// Advent of Code 2019 - input for day 18
//

extension Day18 {
static let rawInput = #"""
#################################################################################
#z..........................#....k#.....#.......#.....#.............#...#.......#
#.###############.#########.#.###.#.###.#Q#######.#.###.#####.#####.#.#.#.#.###.#
#...#...#.....#...#.....#...#.#.#.#...#.#.#.......#..u#..i#.#...#.#.#.#...#...#j#
###W#.#.#####B#.#####.#.#.###.#.#.###.#.#.#.#########.###.#.###.#.#.#.#######.#.#
#.#...#.#...#.#.....#.#.......#.#...#.#.#...#...#.....#.#...#.#.#...#.#.....#.#.#
#.#####.#.#.#.#####.###########.###.#.#.#.###.#.#.###.#.###.#.#.#.#####.###.#.#.#
#...#...#.#.......#.......#.....#...#.#.#...#.#.#.#...#...#.#.#.#.#...#...#...#.#
#.#.#.###.#######.#######.###.###.#####.###.#.#.#.#.###.###.#.#.#.#.#.#.#.#####.#
#.#.#.....#.....#.#.......#...#...#.....#.#.#.#.#.#.....#...#.#.#...#.#.#...#...#
#.#.#######.###.#.#.#######.###.###.###.#.#.#.###.#######N###.#.#####.###.#.#.###
#.#...#...#...#...#.#...#.....#.#.....#.#...#...#.......#.#...#.....#...#.#.#.#.#
###.#.#.#.###.#####.#.#.#.###.#.#.###.#.#.#####.#######.#.###.#####.###.###.#.#.#
#...#.#.#...#.#...#.#.#...#...#.#.#...#.#.#.O...#.....#...#.....#...#.......#...#
#.###.#.#.###.###.#.###.###.###.#.#.###.#.#.#####.###.#.###.###.#.#############.#
#.#...#.#.........#...#...#.....#.#.#.#.#...#.....#...#.#...#.#.#.....#.........#
#.#####.#############.###.#####.###.#.#.###.#.#####.###.#.###.#.#####.#.#########
#.#...#.#.#.........#.#...#...#.....#...#...#.#...#.#.....#.........#.#.#.....#.#
#.#.#.#.#.#.#######.#.#####.#.###########.###.#.###.#################.#.#.###.#.#
#.#.#.#...#.#.....#...#...#.#.#.........#...#.#...#.......#.....#....w#.#.#.#.#.#
#.#.#.###.#.###.#.#.###.#.#.#.#.#######.###.#.#.#.#######.#.###.#.#####.#.#.#.#.#
#...#.#...#...#.#.#.#...#.#.#...#.#...#.#...#.#.#...#.......#.#...#...#...#.#.#.#
#.###.#.#####.#.###.#####.#.#####.#.#.#.#.###.###.#.#.#####.#.#####.#.#####.#.#.#
#...#.#.#...#.#.........#.#.#...#...#...#...#...#.#...#...#.#...#...#...#...#.#.#
#####.#.#.###.#.#######.#.#.###.#.#########.###.#######.#.#####.###.#####.#.#.#.#
#.....#.#...#.#.#...#...#...#...#.#.....#.#...#.#...#...#...#...#...#.....#...#.#
#.#.###.###.#.###.#.#.#######.#.#.#.###.#.###.#.#.#.#.#####.#.###.###M#########.#
#.#.#...#...#.....#.#...#.....#.#.#.#.#.#.#...#...#.#.#.....#.#.#...#.........#.#
#.###.###.#.#######.#####.#.#####.#.#.#.#.#.#######.#.#.###.#.#.#.#.#########.#.#
#.....#...#.#.....#.......#...#...#.#...#.#.#.....#.#.#.#...#.#...#...........#.#
#.#####.#.###.###.###########.#.###.#####.#.###.###.#.#.#####.#.#####.#######.#.#
#.#.....#.#...#.......#.....#...#...#...#.#...#...#.#.#.....#.#.#...#.#.....#...#
#.###.#.###.###.#####.###.#######.#.#.#.#.###.###.#.#.#####.#.###.#.###.###.#####
#...#.#.....#.#.....#...#.........#.#.#.#...#...#.#...#.....#.....#...#...#.....#
###.#######.#.#####.###.###.#########.#.###.###.#.#####.#############.###.#####.#
#.#...#...#...#...#...#...#.....#.....#.#.....#.......#.#...#.......#.....#.D.#.#
#.###.#.#.###.###.###.###.###.#.#.#####.#.###.#####.###.#.#.#.###.#.#########.#.#
#...#...#...#.......#...#.E.#.#...#...#.#...#.#.....#...#.#...#...#.#.........#c#
#.#.#######.###########.###.#######.#.#.#.#.###.#####.###.#####.#####.#####.###.#
#.#.....................#...........#.....#.........#.........#...........#.....#
#######################################.@.#######################################
#.......#.....#.........#...........#.............#.....#...#.......#...........#
#.#####.#.###.#.#####.###.#####.###.###.#.###.###.###.###.#.#.#.###.#.#####.###.#
#.#...#.#.#...#.T...#.....#...#.#.....#.#.#...#.#.....#...#.#.#.#...#....a#...#.#
#.#.#.###.#.#######.#####.#.#.#.#####.#.#.#.###.#####.#.###.#.#.#########.###.#.#
#...#.....#.........#...#...#.#.....#...#.#.#........e#...#...#.S.#.......#...#.#
#####################.#.###########.###.#.#.#.###########.#######.#.#######.###.#
#d..#...#.........C...#.#.......#...#...#.#.#.#.........#.#.#.....#.#...#...#..y#
#.#.#.#.#.#########.###.#.#####.#.###.###.#.###.#######.#.#.#.#####.###.#.###.###
#.#.#.#.......#...#.#...#.#.....#.#...#.#.#...#...#...#...#.#.....#.#...#.#.....#
#.#.#.#########.#.###.###.###.###.#.###.#.###.###.#.#######.#####.#.#.###.#####.#
#.#...#.#.......#.#.G.#.....#.....#...#.#.#...#...#.....#.....#.#...#...#.....#.#
#.#####.#.#######.#.###.###.#########.#.#.#.###.#####.#.#.#.#.#.#######.#####.#.#
#.#.....#.#.........#...#.#.....#...#.#.#.#.#...#...#.#.#.#.#.#.......#.....#.#.#
#Y###.###F#############.#.#####.###.#.#.#.#.#.###.#.#.#.###.#.#####.#.#####.#.#.#
#...#.#...#.....P.....#.......#...#.....#.#.#.....#...#.....#.#.....#.#.....#.#.#
###.#.#.#.#.#########.#######.###.#####.###.#################.#.#####.#.#####.#.#
#...#.#.#.#r#.........#.........#.....#.#...#...#o..........#...#.......#.....#.#
#.###.#.###.#######.###############.#.###.###.#.#.#.#####.###.###########.#####.#
#.#...#...#.......#.....#...#.....#.#...#.....#.#.#.....#.#...#........p#.#...#.#
#.#.#.###.#######.#####.#.#.#.###.#####.#.#####.#.#####.###.###.#######.#.#.###.#
#...#.A.#...X...#.#...#.#.#...#.#.#...#.#..t#.#...#...#...#.#...#...#...#.#.....#
#######.#######.#.#R###.#.#####.#.#.#.#.###.#.#####.#####.#.#####.#.#.###.#######
#.#.....#...#...#...#...#...#.#...#.#...#.#.........#q....#.#...#.#...#.........#
#.#.#####.###.#######V###.#.#.#.###.#####.#########.#.#####.#.#.#.#########.###.#
#.#.#.....#...#.....#...#.#.#...#.......#...#.......#.....#.#.#.#v#.......#...#.#
#.#.#.#.###.#.#.#.#.###.#.#.#.#####.###.#.#.#.###########.#.###.#.###.###.###.#.#
#.#.#.#.#...#.#.#.#.#...#.#.#.#...#...#.#.#.#.......#...#.#b..#.#.#...#.#...#.#.#
#.#.#.#.#.###.#.#.###.#####.#.#.#.#####.###.#.#######.#.#.###.#.#.#.###.###.###.#
#...#.#m#...#.#l#.....#.....#.I.#.#...#.#...#.#.......#.....#...#.#.#g....#.#...#
#.#####.###.#.#.#########.#######.#.#.#.#.###.#.#############.###.#.#####.#.#.#.#
#.#.......#.#.#...#.....#.#.#...#...#.#.#...#.#.....#.........#...#....f#.....#.#
#.#.#####.#.#####.#.#.#.#.#.#.#.#####.#.#.#.#.#####.#.#########L#######.#########
#.#...#.#.#.....H.#.#.#...#...#.#...#.#.#.#.....#...#...#.......#.....#.........#
#.###.#.#.#########.#.#####.###.#.#.#.#.#.#######.#####.#.#######.###.#.#######.#
#.....#.#.#...#.....#.Z...#...#.#.#...#.#.#...#...#.....#...#.#.....#.#.......#.#
#######.#.#.#.#.#####.###.###.#.#.#####.#.#.#.#.#U#.#######.#.#.###.#.#########.#
#..s......#.#.#.#...#...#.#...#.#.......#...#.#.#.#...#.....#.....#.#.....#.....#
#.#########.#.###.#.#####.#.###.#######.#####.#.#####.#.###########.#####.#.###.#
#.......K...#...J.#.......#...#........n#.....#.......#............h#......x#...#
#################################################################################
"""#
}