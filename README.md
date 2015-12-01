# textfield_calculator
Simple calculator for text fileds

#Installation and usage

Install it as bower package
`bower install textfield_calculator` or include js and css file to your project.

To run this wedjit add role attribute with name calculator-source-field to your input tag and role attribute with name open-calculator to your button to open calc. That is

        .col-sm-6
          .form-group
            .input-group
              = f.text_field :sum, class: 'form-control text-right', role: 'calculator-source-field'
              .input-group-addon.pad-none
                = link_to image_tag('calc.png'), nil, role: 'open-calculator', class: 'addon-image', title: 'Calculator'
