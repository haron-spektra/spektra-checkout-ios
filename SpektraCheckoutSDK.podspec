Pod::Spec.new do |s|

    s.name         = "SpektraCheckoutSDK"
    s.version      = "0.0.1"
    s.summary      = "Spektra Checkout SDK"
    s.description  = "Spektra Checkout SDK for ios built in Swift 5. Register as a Spektra Merchant and easily implement Specktra checkout to handle mobile payments."
    s.homepage     = "https://github.com/haron-spektra/spektra-checkout-ios.git"
    s.license      = { :type => "MIT", :text => "The MIT License (MIT) \n Copyright (c) Spektra Inc <admin@spektra.co> \n Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files" }
    s.author             = { "Spektra Inc" => "admin@spektra.co" }
    s.ios.deployment_target = '10.0'
    s.ios.vendored_frameworks = 'SpektraCheckoutSDK.framework'
    s.source            = { :http => 'https://s3.us-east-2.amazonaws.com/spektrafiles/SP-SDK-1-e51069b5-36fa-40e6-a75c-076b768d324b.zip' }
    s.exclude_files = "Classes/Exclude"
    
  end
