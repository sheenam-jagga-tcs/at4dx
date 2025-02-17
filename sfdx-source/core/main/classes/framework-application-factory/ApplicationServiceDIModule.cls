/**
 * Copyright (c) 2020, John M. Daniel & John Storey
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without modification, 
 *   are permitted provided that the following conditions are met:
 *
 * - Redistributions of source code must retain the above copyright notice, 
 *      this list of conditions and the following disclaimer.
 * - Redistributions in binary form must reproduce the above copyright notice, 
 *      this list of conditions and the following disclaimer in the documentation 
 *      and/or other materials provided with the distribution.
 * - Neither the name of the John M. Daniel, nor the names of its contributors 
 *      may be used to endorse or promote products derived from this software without 
 *      specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND 
 *  ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES 
 *  OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL 
 *  THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, 
 *  EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
 *  OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY
 *  OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 *  ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
**/

/**
 *
 * di_Module based class used to manage the Application Factory mappings of for services
 */
public class ApplicationServiceDIModule 
    extends di_Module
{
    @TestVisible
    private static List<ApplicationFactory_ServiceBinding__mdt> bindingRecords = new List<ApplicationFactory_ServiceBinding__mdt>();

    static
    {
        bindingRecords = prioritizeBindings(
            [SELECT DeveloperName, QualifiedAPIName, To__c, BindingInterface__c, Priority__c
            FROM ApplicationFactory_ServiceBinding__mdt
            ORDER BY Priority__c DESC NULLS FIRST]);
            // Lower priority records are added first and overwritten if higher priority items exist.
            // If priority value is duplicated, the priority item is indeterminant.
    }

    public override void configure() 
    {
        for ( ApplicationFactory_ServiceBinding__mdt bindingConfig : bindingRecords )
        {
            apex();
            try {
                Type.forName(bindingConfig.BindingInterface__c);
            } catch (TypeException te) {
                throw new di_Injector.InjectorException('Service Interface ' + bindingConfig.BindingInterface__c + ' referened by binding ' + bindingConfig.DeveloperName + ' does not exist.');
            }
            bind(bindingConfig.BindingInterface__c);
            data(bindingConfig);
            to(bindingConfig.To__c);
        }
    }

    @TestVisible
    private static List<ApplicationFactory_ServiceBinding__mdt> prioritizeBindings(List<ApplicationFactory_ServiceBinding__mdt> rawBindings)
    {
        Map<String, ApplicationFactory_ServiceBinding__mdt> prioritizedMap = new Map<String, ApplicationFactory_ServiceBinding__mdt>();
        for (ApplicationFactory_ServiceBinding__mdt binding : rawBindings)
        {
            prioritizedMap.put(binding.BindingInterface__c, binding);
        }
        return prioritizedMap.values();
    }
}