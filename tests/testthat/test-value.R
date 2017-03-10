describe('type()', {
  expect_equal(type(NULL), 'null')

  expect_equal(type(TRUE), 'bool')
  expect_equal(type(FALSE), 'bool')

  expect_equal(type(as.integer(42)), 'int')
  expect_equal(type(as.integer(1000000000)), 'int')

  expect_equal(type(3.14), 'flt')
  expect_equal(type(pi), 'flt')
  expect_equal(type(1.1e-20), 'flt')

  expect_equal(type(''), 'str')
  expect_equal(type('Yo!'), 'str')

  expect_equal(type(vector()), 'arr')
  expect_equal(type(c(1, 2, 3)), 'arr')

  expect_equal(type(list()), 'obj')
  expect_equal(type(list(a=1, b=2)), 'obj')

  expect_equal(type(data.frame(a=1:10, b=11:20)), 'tab')

  expect_equal(type(list(type='html', content='<img>')), 'html')
  expect_equal(type(list(type='png', content='')), 'png')
  expect_equal(type(list(type=1)), 'obj')

  expect_equal(type(function () {}), 'unk')
})

describe('pack()', {
  check <- function (x, type, format, content) {
    p <- pack(x)
    expect_equal(p$type, type)
    expect_equal(p$format, format)
    expect_equal(p$content, content)
  }

  it("works for primitive types", {
    check(NULL, 'null', 'text', 'null')
    check(NA, 'null', 'text', 'null')

    check(TRUE, 'bool', 'text', 'true')
    check(FALSE, 'bool', 'text', 'false')

    check(as.integer(42), 'int', 'text', '42')
    check(as.integer(1000000000), 'int', 'text', '1000000000')

    check(3.14, 'flt', 'text', '3.14')
    check(pi, 'flt', 'text', '3.14159265358979')

    check(1e10, 'flt', 'text', '1e+10')
    check(1e-10, 'flt', 'text', '1e-10')
  })

  it("works for lists", {
    check(list(), 'obj', 'json', '{}')
    check(list(a=1, b=3.14, c='foo', d=list(e=1, f=2)), 'obj', 'json', '{"a":1,"b":3.14,"c":"foo","d":{"e":1,"f":2}}')
  })

  it("works for vectors", {
    check(vector(), 'arr', 'json', '[]')
    check(1:4, 'arr', 'json', '[1,2,3,4]')
    check(seq(1.1,2.1,1), 'arr', 'json', '[1.1,2.1]')
  })

  it("works for data frames and matrices", {
    check(data.frame(), 'tab', 'csv', '')
    check(data.frame(a=1:3), 'tab', 'csv', 'a\n1\n2\n3')
    check(data.frame(a=1:3,b=c('x','y','z')), 'tab', 'csv', 'a,b\n1,x\n2,y\n3,z')

    check(matrix(), 'null', 'text', 'null')
    check(matrix(data=1:4,nrow=2), 'tab', 'csv', 'V1,V2\n1,3\n2,4')
  })

  it("works for recorded plots", {
    # For recodPlot to work..
    png(tempfile())
    dev.control('enable')

    plot(mpg~disp, mtcars)
    p <- pack(recordPlot())
    expect_equal(p$type, 'plot')
    expect_equal(p$format, 'png')
    expect_equal(str_sub(p$content, 1, 15), 'data:image/png;')
  })

  if (require('ggplot2', quietly=T)) {
    it("works for ggplots", {
      p <- pack(ggplot(mtcars) + geom_point(aes(x=disp,y=mpg)))
      expect_equal(p$type, 'plot')
      expect_equal(p$format, 'png')
      expect_equal(str_sub(p$content, 1, 15), 'data:image/png;')
    })
  }
})

describe('unpack()', {
  it("can take a list or a JSON string", {
    expect_null(unpack('{"type":"null","format":"text","content":"null"}'))
    expect_null(unpack(list(type='null',format='text',content='null')))
  })

  it("errors if package is malformed", {
    expect_error(unpack(1), 'should be a list')

    expect_error(unpack(list()), 'should have fields `type`, `format`, `content`')
    expect_error(unpack("{}"))
    expect_error(unpack(list(type='null')))
    expect_error(unpack(list(type='null', format='text')))
  })

  it("works for primitive types", {
    expect_null(unpack(list(type='null',format='text',content='null')))

    expect_true(unpack(list(type='bool',format='text',content='true')))
    expect_false(unpack(list(type='bool',format='text',content='false')))

    expect_equal(unpack(list(type='int',format='text',content='42')), 42)
    expect_equal(unpack(list(type='int',format='text',content='1000000000')), as.integer(1000000000))

    expect_equal(unpack(list(type='flt',format='text',content='3.12')), 3.12)
    expect_equal(unpack(list(type='flt',format='text',content='1e20')), 1e20)
  })

  it("works for objects", {
    expect_equivalent(unpack(list(type='obj',format='json',content='{}')), list())
    expect_equal(unpack(list(type='obj',format='json',content='{"a":1,"b":"foo","c":[1,2,3]}')), list(a=1,b="foo",c=1:3))
  })

  it("works for arrays", {
    expect_equal(unpack(list(type='arr',format='json',content='[]')), vector())
    expect_equal(unpack(list(type='arr',format='json',content='[1,2,3,4,5]')), 1:5)
  })

  it("works for tabular data", {
    expect_equal(unpack(list(type='tab',format='csv',content='a,b\n1,x\n2,y\n3,z')), data_frame(a=1:3, b=c('x','y','z')))
  })
})



